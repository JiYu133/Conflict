"""Check the configured logger in a fresh Godot project, without UID sidecars.

Run: python tests/logger_bootstrap_check.py --godot godot_console.exe
"""

import argparse
from pathlib import Path
import re
import shutil
import subprocess
import tempfile


def run_engine(executable: str, project: Path, *arguments: str) -> str:
    result = subprocess.run(
        [executable, "--headless", "--path", str(project), *arguments],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        timeout=90,
    )
    output = result.stdout + result.stderr
    if result.returncode or "SCRIPT ERROR:" in output or "ERROR:" in output:
        raise RuntimeError(output)
    return output


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--godot", default="godot_console.exe")
    args = parser.parse_args()
    repository = Path(__file__).resolve().parents[1]
    settings = (repository / "project.godot").read_text(encoding="utf-8")
    entry = re.search(r'^GlobalLogger="([^"]+)"$', settings, re.MULTILINE)
    if entry is None:
        raise RuntimeError("project.godot has no GlobalLogger autoload")

    with tempfile.TemporaryDirectory(prefix="conflict-logger-") as directory:
        project = Path(directory)
        logger = project / "classes/services/game_logger.gd"
        logger.parent.mkdir(parents=True)
        # Copy only tracked source, never the developer's .uid or .godot cache.
        shutil.copyfile(repository / "classes/services/game_logger.gd", logger)
        shutil.copyfile(repository / "classes/services/logger_service.gd", logger.parent / "logger_service.gd")
        (project / "project.godot").write_text(
            'config_version=5\n[application]\nconfig/name="Logger bootstrap check"\n'
            '[autoload]\nGlobalLogger="' + entry.group(1) + '"\n',
            encoding="utf-8",
        )
        (project / "check.gd").write_text(
            'extends Node\nfunc _ready() -> void:\n'
            '\tGlobalLogger.info("BootstrapCheck", "logger is available")\n'
            '\tprint("logger_bootstrap_check=ok")\n\tget_tree().quit(0)\n',
            encoding="utf-8",
        )
        (project / "check.tscn").write_text(
            '[gd_scene load_steps=2 format=3]\n'
            '[ext_resource type="Script" path="res://check.gd" id="1"]\n'
            '[node name="BootstrapCheck" type="Node"]\nscript = ExtResource("1")\n',
            encoding="utf-8",
        )
        run_engine(args.godot, project, "--editor", "--import", "--quit")
        output = run_engine(
            args.godot, project, "res://check.tscn", "--quit-after", "120"
        )
        if "logger_bootstrap_check=ok" not in output:
            raise RuntimeError("Logger bootstrap did not complete:\n" + output)
    print("logger_bootstrap_check=ok (clean import and runtime)")


if __name__ == "__main__":
    main()
