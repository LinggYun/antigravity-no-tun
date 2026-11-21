# 反重力免 TUN 代理启动器

让 Google Antigravity 在不开启 TUN 模式的情况下正常联网，且**只让它自己走代理**，其他软件完全不受影响。适用于 Windows，已在 Antigravity 2.33.0 + Clash Verge（mihomo）上验证通过。

**为什么需要它**

Antigravity 的界面部分会跟随系统代理，但真正发模型请求的底层 Go 服务（`language_server.exe`）不读 Windows 系统代理设置。只开系统代理没用，只有开 TUN 在网络层强行劫持流量才能连通——代价是全部软件都被接管。这个启动器只给 Antigravity 这一棵进程树注入代理环境变量和启动参数，绕开 TUN。

**怎么用**

先打开你的代理软件，确认本机 HTTP/混合端口可用（Clash 默认 `7897`，365VPN 默认 `57777`，其他软件按实际端口改脚本第一处的 `proxy` 变量）。端口怎么看：打开 Windows 设置 → 网络和 Internet → 代理，看"代理服务器"里的地址；或者在代理软件界面里找"本地端口 / HTTP 端口"。然后双击 `Antigravity-Proxy.vbs`，在弹窗里点"是"。它会关掉旧的 Antigravity 进程，再用代理重新启动；关闭动作是必要的，因为 Antigravity 是单实例程序，不清理旧进程的话新请求会被转发给没有代理配置的旧实例。

以后每次都用这个脚本打开，不要再点原来的 Antigravity 图标。想更顺手就把脚本的快捷方式放到桌面或任务栏，并换成原程序的图标。

**常见问题**

报连接失败先检查代理软件是否在运行、端口是否和脚本里一致。切换启动方式后首次可能出现一次 `Model unavailable, retrying`，随后自动恢复，不用处理。如果个别请求仍然超时，说明某些 Go 底层调用连环境变量也不认，兜底办法是用 Proxifier 按进程名只放行 `Antigravity.exe` 和 `language_server.exe` 走代理。

**致谢**

本方案由作者与 AI 协作伙伴 hy4 flash 共同排查定位并整理成文。
