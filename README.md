# Wi-Fi ADB Module

KSU / Magisk 模块，用于在 Android 上按需开启或关闭 Wi-Fi ADB 无线调试。

## 功能

- 默认关闭 Wi-Fi ADB，需要时手动开启
- KSU WebUI 管理面板
- KSU 外部执行按钮一键切换
- `control.sh` 命令行控制
- 自定义 ADB 端口，启用状态下保存后即时生效
- 运行状态和日志查看
- 无需重启 Android 系统即可自由开启/关闭

## 下载

- 成品包：`dist/wifi-adb-module-v2.1-instant-toggle.zip`
- 更新日志：`CHANGELOG.md`

## 安装

1. 下载 Release zip
2. 在 KSU / Magisk 管理器中刷入
3. 重启一次以加载模块服务
4. 后续开启/关闭 Wi-Fi ADB 不需要重启系统

## WebUI

在 KSU 管理器中打开模块 WebUI，可直接切换 Wi-Fi ADB 开关、修改端口、查看状态和日志。

## 命令

```sh
su -c sh /data/adb/modules/wifi-adb/control.sh start
su -c sh /data/adb/modules/wifi-adb/control.sh stop
su -c sh /data/adb/modules/wifi-adb/control.sh toggle
su -c sh /data/adb/modules/wifi-adb/control.sh set-port 5555
su -c sh /data/adb/modules/wifi-adb/control.sh status
```

## 连接

开启后在电脑端执行：

```sh
adb connect <IP>:5555
```

## 版本历史

- **v2.1**：修复关闭不即时生效，支持 KSU/WebUI/命令行即时开启关闭
- **v2.0**：重构 WebUI 和状态监控
