# Changelog

## v2.1 - 2026-05-30

### Fixed

- Make Wi-Fi ADB stop immediately when disabled from KernelSU WebUI, action button, or `control.sh`.
- Stop writing only `ENABLED=0` without applying the runtime ADB state.
- Prevent the background service from repeatedly restarting `adbd` while Wi-Fi ADB is disabled.
- Exit the background service after disabling Wi-Fi ADB when KernelSU/Magisk marks the module disabled.

### Changed

- Default install state is now disabled. Turn Wi-Fi ADB on only when needed.
- Port changes now apply immediately when Wi-Fi ADB is already enabled.
- WebUI falls back to a stopped state if `status.json` is missing.

### Commands

```sh
su -c sh /data/adb/modules/wifi-adb/control.sh start
su -c sh /data/adb/modules/wifi-adb/control.sh stop
su -c sh /data/adb/modules/wifi-adb/control.sh toggle
su -c sh /data/adb/modules/wifi-adb/control.sh set-port 5555
```

### Package

- Bumped module version from `v2.0` to `v2.1`.
- Bumped `versionCode` from `20` to `21`.
- Built artifact: `dist/wifi-adb-module-v2.1-instant-toggle.zip`.
