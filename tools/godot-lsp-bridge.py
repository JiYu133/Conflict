#!/usr/bin/env python3
"""
Godot headless LSP → stdio 桥接脚本

启动 Godot headless LSP（TCP 模式），然后将标准输入/输出与 TCP socket 双向桥接。
使得仅支持 stdio 的 LSP 客户端（如 OpenCode）可以使用 Godot 内置的 TCP LSP。

使用环境变量配置：
  GODOT_PATH     - Godot 可执行文件路径（默认: /opt/homebrew/bin/godot）
  PROJECT_PATH   - Godot 项目路径（默认: 自动从 CWD/git 根目录检测）
  LSP_HOST       - LSP 监听地址（默认: 127.0.0.1）
  READY_TIMEOUT  - 等待 Godot LSP 就绪的超时秒数（默认: 30）
"""

import os
import sys
import socket
import subprocess
import select
import signal
import time
import threading
import atexit
from pathlib import Path


def find_project_root() -> str:
    """从当前工作目录向上查找 project.godot 文件"""
    cwd = Path.cwd()
    for parent in [cwd, *cwd.parents]:
        if (parent / "project.godot").exists():
            return str(parent)
    return str(cwd)


def find_free_port(host: str = "127.0.0.1") -> int:
    """查找可用的 TCP 端口"""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((host, 0))
        return s.getsockname()[1]


def wait_for_port(host: str, port: int, timeout: float = 30.0) -> bool:
    """等待 TCP 端口变为可连接状态"""
    import time
    start = time.time()
    while time.time() - start < timeout:
        try:
            with socket.create_connection((host, port), timeout=1.0):
                return True
        except (ConnectionRefusedError, OSError):
            time.sleep(0.5)
    return False


class LSPBridge:
    """Godot TCP LSP ↔ stdio 桥接器"""

    def __init__(self):
        self._godot_proc: subprocess.Popen | None = None
        self._tcp_sock: socket.socket | None = None
        self._running = True

    def start_godot(self, godot_path: str, project_path: str, host: str, port: int) -> None:
        """启动 Godot headless LSP"""
        cmd = [
            godot_path,
            "--path", project_path,
            "--editor",
            "--headless",
            "--lsp-port", str(port),
        ]

        sys.stderr.write(f"[bridge] 启动 Godot: {' '.join(cmd)}\n")
        sys.stderr.flush()

        self._godot_proc = subprocess.Popen(
            cmd,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
            stdin=subprocess.DEVNULL,
            preexec_fn=os.setsid if sys.platform != "win32" else None,
        )

        atexit.register(self._cleanup)

        # 异步读取 Godot stderr 以便调试
        def log_stderr():
            for line in self._godot_proc.stderr:
                if self._godot_proc and self._godot_proc.poll() is None:
                    sys.stderr.write(f"[godot] {line}")
                    sys.stderr.flush()

        threading.Thread(target=log_stderr, daemon=True).start()

    def connect_tcp(self, host: str, port: int) -> None:
        """连接到 Godot LSP TCP 端口"""
        self._tcp_sock = socket.create_connection((host, port))
        self._tcp_sock.setblocking(False)
        sys.stderr.write(f"[bridge] 已连接到 Godot LSP {host}:{port}\n")
        sys.stderr.flush()

    def run(self) -> None:
        """主循环 — 双向转发 stdin/stdout ↔ TCP socket"""
        while self._running:
            # 检查 Godot 进程是否存活
            if self._godot_proc and self._godot_proc.poll() is not None:
                sys.stderr.write(f"[bridge] Godot 进程已退出 (code={self._godot_proc.returncode})\n")
                sys.stderr.flush()
                break

            try:
                readable, _, _ = select.select(
                    [sys.stdin.buffer, self._tcp_sock],
                    [],
                    [],
                    1.0,
                )
            except (ValueError, OSError):
                break

            for r in readable:
                if r is sys.stdin.buffer:
                    data = sys.stdin.buffer.read(65536)
                    if not data:
                        self._running = False
                        break
                    try:
                        self._tcp_sock.sendall(data)
                    except OSError:
                        self._running = False
                        break

                elif r is self._tcp_sock:
                    try:
                        data = self._tcp_sock.recv(65536)
                    except OSError:
                        data = b""
                    if not data:
                        self._running = False
                        break
                    sys.stdout.buffer.write(data)
                    sys.stdout.buffer.flush()

    def _cleanup(self) -> None:
        """清理子进程和 socket"""
        if self._tcp_sock:
            try:
                self._tcp_sock.close()
            except OSError:
                pass
            self._tcp_sock = None

        if self._godot_proc:
            proc = self._godot_proc
            try:
                if sys.platform == "win32":
                    proc.terminate()
                else:
                    os.killpg(os.getpgid(proc.pid), signal.SIGTERM)
                proc.wait(timeout=5)
            except Exception:
                try:
                    proc.kill()
                    proc.wait(timeout=3)
                except Exception:
                    pass
            self._godot_proc = None


def default_godot_path() -> str:
    """按平台猜测 Godot 可执行文件位置；找不到就退回 PATH 里的 godot。"""
    candidates: list[str] = []
    if sys.platform == "win32":
        local = os.environ.get("LOCALAPPDATA", "")
        if local:
            candidates.append(str(Path(local) / "Microsoft" / "WinGet" / "Links" / "godot.exe"))
        candidates += [
            r"C:\Program Files\Godot\godot.exe",
            r"C:\Program Files (x86)\Godot\godot.exe",
        ]
    elif sys.platform == "darwin":
        candidates += [
            "/opt/homebrew/bin/godot",
            "/usr/local/bin/godot",
            "/Applications/Godot.app/Contents/MacOS/Godot",
        ]
    else:
        candidates += ["/usr/bin/godot", "/usr/local/bin/godot"]

    for path in candidates:
        if Path(path).exists():
            return path
    # 交给系统 PATH 解析
    return "godot.exe" if sys.platform == "win32" else "godot"


def main() -> None:
    godot_path = os.environ.get("GODOT_PATH", default_godot_path())
    project_path = os.environ.get("PROJECT_PATH", find_project_root())
    lsp_host = os.environ.get("LSP_HOST", "127.0.0.1")
    ready_timeout = float(os.environ.get("READY_TIMEOUT", "30"))

    # 处理 SIGTERM/SIGINT 确保清理
    bridge = LSPBridge()
    signal.signal(signal.SIGTERM, lambda *_: bridge._cleanup() or sys.exit(0))
    signal.signal(signal.SIGINT, lambda *_: bridge._cleanup() or sys.exit(0))

    port = find_free_port(lsp_host)

    sys.stderr.write(f"[bridge] Godot: {godot_path}\n")
    sys.stderr.write(f"[bridge] 项目: {project_path}\n")
    sys.stderr.write(f"[bridge] 端口: {port}\n")
    sys.stderr.flush()

    bridge.start_godot(godot_path, project_path, lsp_host, port)

    sys.stderr.write(f"[bridge] 等待 Godot LSP 就绪（最多 {ready_timeout}s）...\n")
    sys.stderr.flush()

    if not wait_for_port(lsp_host, port, ready_timeout):
        sys.stderr.write("[bridge] 错误: Godot LSP 未能在超时时间内就绪\n")
        sys.stderr.flush()
        bridge._cleanup()
        sys.exit(1)

    bridge.connect_tcp(lsp_host, port)
    bridge.run()
    bridge._cleanup()


if __name__ == "__main__":
    main()
