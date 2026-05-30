#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR/common.sh"

load_config

case "$1" in
start|enable|on)
 enable_wifi_adb
 echo "Wi-Fi ADB enabled"
 ;;
stop|disable|off)
 disable_wifi_adb
 echo "Wi-Fi ADB disabled"
 ;;
toggle)
 if [ "$ENABLED" = "1" ]; then
  disable_wifi_adb
  echo "Wi-Fi ADB disabled"
 else
  enable_wifi_adb
  echo "Wi-Fi ADB enabled"
 fi
 ;;
status)
 if [ -f "$STATUS_FILE" ]; then
  cat "$STATUS_FILE"
 else
  update_status "" stopped
  cat "$STATUS_FILE"
 fi
 ;;
set-port)
 case "$2" in
  ''|*[!0-9]*)
   echo "Invalid port"
   exit 1
   ;;
 esac
 if [ "$2" -lt 1 ] || [ "$2" -gt 65535 ]; then
  echo "Invalid port"
  exit 1
 fi
 ADB_PORT="$2"
 write_config
 if [ "$ENABLED" = "1" ]; then
  enable_wifi_adb
  echo "Port=$ADB_PORT, restarted"
 else
  update_status "" stopped
  echo "Port=$ADB_PORT"
 fi
 ;;
*)
 echo "Usage: control.sh {start|stop|toggle|status|set-port <1-65535>}"
 exit 1
 ;;
esac
