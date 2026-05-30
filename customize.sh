#!/system/bin/sh
# Wi-Fi ADB Module - customize.sh

SKIPUNZIP=1

unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/service.sh"  0 0 0755
set_perm "$MODPATH/control.sh"  0 0 0755
set_perm "$MODPATH/action.sh"   0 0 0755

# 初始化配置（默认关闭，端口 5555）
if [ ! -f "$MODPATH/config" ]; then
    cat > "$MODPATH/config" << 'EOF'
ADB_PORT=5555
ENABLED=0
EOF
fi

# 初始化日志
mkdir -p "$MODPATH/webroot"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 模块安装完成" > "$MODPATH/webroot/log.txt"

ui_print "=========================================="
ui_print "   Wi-Fi ADB Module v2.1"
ui_print "=========================================="
ui_print "  默认关闭，需要时手动开启"
ui_print "  支持 WebUI 管理面板"
ui_print "  支持即时开启/关闭，无需重启系统"
ui_print "  默认端口: 5555"
ui_print "=========================================="
