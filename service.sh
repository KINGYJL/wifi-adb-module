#!/system/bin/sh
# Wi-Fi ADB Module - service.sh
# 开机自动开启 Wi-Fi ADB

MODDIR=${0%/*}
LOG_FILE="$MODDIR/webroot/log.txt"
STATUS_FILE="$MODDIR/webroot/status.json"
CONFIG_FILE="$MODDIR/config"

# 默认配置
ADB_PORT=5555
ENABLED=1

# 读取配置
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        . "$CONFIG_FILE"
    else
        cat > "$CONFIG_FILE" << 'EOF'
ADB_PORT=5555
ENABLED=1
EOF
    fi
}

# 写日志
log_msg() {
    local time=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$time] $1" >> "$LOG_FILE"
    if [ -f "$LOG_FILE" ]; then
        tail -200 "$LOG_FILE" > "$LOG_FILE.tmp"
        mv "$LOG_FILE.tmp" "$LOG_FILE"
    fi
}

# 更新状态JSON
update_status() {
    local ip=$1
    local state=$2
    cat > "$STATUS_FILE" << EOF
{
  "enabled": $ENABLED,
  "port": $ADB_PORT,
  "ip": "$ip",
  "state": "$state",
  "updated": "$(date '+%Y-%m-%d %H:%M:%S')"
}
EOF
}

# 获取 Wi-Fi IP
get_wifi_ip() {
    local ip=""
    ip=$(ip addr show wlan0 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
    if [ -z "$ip" ]; then
        ip=$(ifconfig wlan0 2>/dev/null | grep 'inet addr' | awk -F: '{print $2}' | awk '{print $1}')
    fi
    if [ -z "$ip" ]; then
        ip=$(getprop dhcp.wlan0.ipaddress 2>/dev/null)
    fi
    echo "$ip"
}

# 等待系统启动
wait_boot() {
    while [ "$(getprop sys.boot_completed)" != "1" ]; do
        sleep 3
    done
    sleep 5
}

# 开启 Wi-Fi ADB
start_adb() {
    setprop service.adb.tcp.port "$ADB_PORT"
    stop adbd
    start adbd
    local ip=$(get_wifi_ip)
    log_msg "Wi-Fi ADB 已启动 | 端口: $ADB_PORT | IP: ${ip:-等待WiFi}"
    update_status "${ip:-}" "running"
}

# 关闭 Wi-Fi ADB
stop_adb() {
    setprop service.adb.tcp.port ""
    stop adbd
    start adbd
    log_msg "Wi-Fi ADB 已关闭，恢复 USB 模式"
    update_status "" "stopped"
}

# 主流程
log_msg "===== 模块启动 ====="
load_config

wait_boot
log_msg "系统启动完成"

if [ "$ENABLED" = "1" ]; then
    start_adb
else
    log_msg "模块已禁用，跳过"
    update_status "" "disabled"
fi

# 持续监控
while true; do
    sleep 15
    load_config
    if [ "$ENABLED" = "1" ]; then
        ip=$(get_wifi_ip)
        update_status "${ip:-}" "running"
    fi
done
