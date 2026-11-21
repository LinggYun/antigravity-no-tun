' Antigravity proxy launcher for Windows
' Scope proxy to the Antigravity process tree only - no TUN, no system-wide changes.
' Verified on Antigravity 2.33.0 + Clash Verge (mihomo) mixed port.
Option Explicit

Dim ws, env, proxy, exePath, cmdLine, ans

' ==== EDIT THIS IF YOUR PROXY PORT DIFFERS ====
' Common ports: Clash Verge = 7897, 365VPN = 57777
proxy = "http://127.0.0.1:57777"

Set ws = CreateObject("WScript.Shell")
exePath = ws.ExpandEnvironmentStrings("%LOCALAPPDATA%") & _
          "\Programs\antigravity\Antigravity.exe"

ans = MsgBox( _
  "Restart Antigravity with proxy (no TUN)?" & vbCrLf & _
  "All running Antigravity processes will be closed." & vbCrLf & _
  "Save unsaved work before continuing." & vbCrLf & vbCrLf & _
  "Continue?", vbYesNo + vbQuestion, "Antigravity Proxy Launcher")

If ans <> vbYes Then WScript.Quit

' Close stale instances so the single-instance mechanism cannot reuse a proxy-less environment.
ws.Run "taskkill /F /IM language_server.exe /T", 0, True
ws.Run "taskkill /F /IM Antigravity.exe /T", 0, True
WScript.Sleep 2000

' Per-process proxy environment - inherited only by the process launched below.
Set env = ws.Environment("PROCESS")
env("HTTP_PROXY")  = proxy
env("HTTPS_PROXY") = proxy
env("ALL_PROXY")   = proxy
env("http_proxy")  = proxy
env("https_proxy") = proxy
env("all_proxy")   = proxy
env("GRPC_PROXY")  = proxy
env("grpc_proxy")  = proxy
env("NO_PROXY")    = "localhost,127.0.0.1,::1"
env("no_proxy")    = "localhost,127.0.0.1,::1"

cmdLine = """" & exePath & """" & _
          " --proxy-server=" & proxy & _
          " --proxy-bypass-list=<local>;localhost;127.0.0.1;::1"

ws.Run cmdLine, 0, False
