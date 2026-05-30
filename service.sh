#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR/common.sh"

LOCK=/dev/.wifiadb.lock
[ -f "$LOCK" ] && kill -0 "$(cat "$LOCK" 2>/dev/null)" 2>/dev/null && exit 0
echo $$ > "$LOCK"
trap 'rm -f "$LOCK"' EXIT

while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 3; done
sleep 5

load_config
if [ -f "$MODDIR/disable" ]; then
 disable_wifi_adb
 log_msg "Module disabled, service exited"
 exit 0
fi

if [ "$ENABLED" = "1" ]; then
 enable_wifi_adb
else
 update_status "" stopped
 log_msg "Wi-Fi ADB is disabled"
fi

last_ip=""
stopped_applied=1
while true; do
 sleep 15

 if [ -f "$MODDIR/disable" ]; then
  disable_wifi_adb
  log_msg "Module disabled, service exited"
  exit 0
 fi

 load_config
 ip=$(get_ip)
 svc=$(getprop init.svc.adbd)

 if [ "$ENABLED" != "1" ]; then
  if [ "$stopped_applied" != "1" ]; then
   disable_wifi_adb
  else
   update_status "" stopped
  fi
  stopped_applied=1
  last_ip=""
  continue
 fi

 stopped_applied=0
 current_port=$(getprop service.adb.tcp.port)
 if [ "$svc" != "running" ] || [ "$current_port" != "$ADB_PORT" ]; then
  log_msg "adbd recovered"
  enable_wifi_adb
  ip=$(get_ip)
 fi

 if [ "$ip" != "$last_ip" ]; then
  update_status "$ip" running
  last_ip="$ip"
 fi
done
