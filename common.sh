#!/system/bin/sh
MODDIR=${0%/*}
LOG_FILE="$MODDIR/webroot/log.txt"
STATUS_FILE="$MODDIR/webroot/status.json"
CONFIG_FILE="$MODDIR/config"

log_msg(){
 mkdir -p "$MODDIR/webroot"
 echo "[$(date '+%F %T')] $1" >> "$LOG_FILE"
}

load_config(){
 if [ ! -f "$CONFIG_FILE" ]; then
  cat > "$CONFIG_FILE" <<EOF
ADB_PORT=5555
ENABLED=0
EOF
 fi
 ADB_PORT=$(grep '^ADB_PORT=' "$CONFIG_FILE"|cut -d= -f2)
 ENABLED=$(grep '^ENABLED=' "$CONFIG_FILE"|cut -d= -f2)
 case "$ADB_PORT" in ''|*[!0-9]*) ADB_PORT=5555;; esac
 [ "$ENABLED" = "1" ] || ENABLED=0
}

get_iface(){ ip route 2>/dev/null|awk '/default/ {print $5;exit}'; }

get_ip(){
 iface=$(get_iface)
 ip addr show "$iface" 2>/dev/null|awk '/inet /{print $2}'|cut -d/ -f1|head -n1
}

update_status(){
 mkdir -p "$MODDIR/webroot"
 cat > "$STATUS_FILE" <<EOF
{"enabled":$ENABLED,"port":$ADB_PORT,"ip":"$1","state":"$2","updated":"$(date '+%F %T')"}
EOF
}

write_config(){
 cat > "$CONFIG_FILE" <<EOF
ADB_PORT=$ADB_PORT
ENABLED=$ENABLED
EOF
 chmod 600 "$CONFIG_FILE" 2>/dev/null
}

restart_adbd(){
 stop adbd 2>/dev/null
 sleep 1
 start adbd 2>/dev/null
 sleep 1
}

enable_wifi_adb(){
 load_config
 ENABLED=1
 write_config
 setprop service.adb.tcp.port "$ADB_PORT"
 restart_adbd
 update_status "$(get_ip)" running
 log_msg "Wi-Fi ADB enabled on port $ADB_PORT"
}

disable_wifi_adb(){
 load_config
 ENABLED=0
 write_config
 setprop service.adb.tcp.port -1
 setprop persist.adb.tcp.port "" 2>/dev/null
 restart_adbd
 update_status "" stopped
 log_msg "Wi-Fi ADB disabled"
}
