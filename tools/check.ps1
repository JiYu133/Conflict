# Run with: powershell -ExecutionPolicy Bypass -File tools/check.ps1
param(
    [switch]$Quick,
    [string]$GodotPath = $env:GODOT_PATH,
    [int]$TimeoutSeconds = 120
)

$ErrorActionPreference = 'Stop'
$ProjectPath = Split-Path -Parent $PSScriptRoot

if (-not $GodotPath) {
    $command = Get-Command godot, godot4, godot.console.exe, godot.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($command) { $GodotPath = $command.Source }
}
if (-not $GodotPath) {
    $candidates = @(
        "${env:ProgramFiles(x86)}\Steam\steamapps\common\Godot Engine\godot.windows.opt.tools.64.exe",
        "$env:ProgramFiles\Godot\Godot.exe"
    )
    foreach ($drive in Get-PSDrive -PSProvider FileSystem) {
        $candidates += Join-Path $drive.Root 'SteamLibrary\steamapps\common\Godot Engine\godot.windows.opt.tools.64.exe'
    }
    $GodotPath = $candidates | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1
}
if (-not $GodotPath -or -not (Test-Path -LiteralPath $GodotPath -PathType Leaf)) {
    Write-Host 'Godot not found. Pass -GodotPath or set GODOT_PATH.' -ForegroundColor Red
    exit 1
}

# Read both pipes asynchronously. This waits for GUI builds on PowerShell 5.1
# and captures real diagnostics without matching error-like names inside JSON.
function Test-Godot {
    param([string]$Label, [string]$Arguments, [switch]$Runner)

    $info = New-Object System.Diagnostics.ProcessStartInfo
    $info.FileName = $GodotPath
    $info.Arguments = "--headless --path `"$ProjectPath`" $Arguments"
    $info.WorkingDirectory = $ProjectPath
    $info.UseShellExecute = $false
    $info.CreateNoWindow = $true
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    # Keep headless preferences, logs and shader caches inside this workspace.
    $info.EnvironmentVariables['APPDATA'] = Join-Path $ProjectPath '.appdata'
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $info
    $errors = @()
    try {
        $null = $process.Start()
        $stdout = $process.StandardOutput.ReadToEndAsync()
        $stderr = $process.StandardError.ReadToEndAsync()
        if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
            $process.Kill()
            $process.WaitForExit()
            $errors += "timed out after $TimeoutSeconds seconds"
        }
        $raw = ($stdout.Result + "`n" + $stderr.Result) -split '\r?\n'
        if ($process.ExitCode -ne 0) {
            $errors += "process exited with code $($process.ExitCode)"
        }
    } finally {
        $process.Dispose()
    }

    $logDirectory = Join-Path $ProjectPath '.appdata/regression'
    $null = New-Item -ItemType Directory -Path $logDirectory -Force
    $logName = ($Label -replace '[^a-zA-Z0-9_-]', '_') + '.log'
    [System.IO.File]::WriteAllLines((Join-Path $logDirectory $logName), [string[]]$raw)

    $completed = $false
    foreach ($line in $raw) {
        if ($line -match '^\s*\{') {
            try { $report = $line | ConvertFrom-Json } catch { continue }
            if ($report.PSObject.Properties['status'] -or $report.PSObject.Properties['ok']) {
                $completed = $true
            }
            if (($report.PSObject.Properties['ok'] -and $report.ok -eq $false) -or
                ($report.PSObject.Properties['failed'] -and $report.failed -gt 0) -or
                ($report.PSObject.Properties['status'] -and $report.status -eq 'failed')) {
                $errors += "runner reported failure: $line"
            }
        } elseif ($line -match '^(ads_system|aim_breathing)=') {
            $completed = $true
            if ($line -notmatch '=ok failures=0$') { $errors += $line }
        } elseif ($line -match '^ik_rig_check=') {
            $completed = $true
            if ($line -notmatch '=ok failures=0$') { $errors += $line }
        } elseif ($line -match '^ai_aim_check=') {
            $completed = $true
            if ($line -notmatch '=ok ') { $errors += $line }
        } elseif ($line -match '^\s*(SCRIPT ERROR:|ERROR:)') {
            if ($line -notmatch 'resources still in use at exit') { $errors += $line }
        }
    }
    if ($Runner -and -not $completed) {
        $errors += 'runner did not produce a completion report before the frame limit'
    }
    if ($errors.Count -eq 0) {
        Write-Host "[PASS] $Label" -ForegroundColor Green
    } else {
        Write-Host "[FAIL] $Label ($($errors.Count) errors)" -ForegroundColor Red
        $errors | Select-Object -First 8 | ForEach-Object { Write-Host "       $_" }
    }
    return $errors.Count
}

$totalErrors = Test-Godot -Label 'editor import / script scan' -Arguments '--editor --import'
if ($totalErrors -gt 0) { exit 1 }
$totalErrors += Test-Godot -Label 'project load / autoloads' -Arguments '--quit'
foreach ($scene in @('title/title_screen', 'map/TestMap', 'map/test_map')) {
    $totalErrors += Test-Godot -Label $scene -Arguments "res://assets/$scene.tscn --fixed-fps 60 --quit-after 150"
}
if (-not $Quick) {
    foreach ($runner in @(
        'ik_rig_check',
        'ads_system_runner',
        'aim_breathing_runner',
        'ai_aim_check',
        'headless_debug_api_runner',
        'movement_body_yaw_runner',
        'force_integration_runner',
        'force_system_runner',
        'medical_system_p4_runner',
        'player_audio_interface_runner'
        'player_components_runner'
    )) {
        $totalErrors += Test-Godot -Label $runner -Arguments "res://tests/$runner.tscn --fixed-fps 60 --quit-after 3000" -Runner
    }
}
if ($totalErrors -eq 0) {
    Write-Host 'ALL PASS: 0 errors' -ForegroundColor Green
    exit 0
}
Write-Host "FAILED: $totalErrors error(s) total" -ForegroundColor Red
exit 1
