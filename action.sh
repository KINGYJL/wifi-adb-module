#!/system/bin/sh
# Wi-Fi ADB Module - action.sh
# KSU 外部执行按钮：一键切换 Wi-Fi ADB 开关

MODDIR=${0%/*}
CONFIG_FILE="$MODDIR/config"
CONTROL_SCRIPT="$MODDIR/control.sh"

# 优先使用 control.sh
if [ -f "$CONTROL_SCRIPT" ]; then
    sh "$CONTROL_SCRIPT" toggle
    exit $?
fi

# fallback: 直接修改配置
if [ -f "$CONFIG_FILE" ]; then
    current=$(grep 'ENABLED=' "$CONFIG_FILE" | cut -d= -f2)
    if [ "$current" = "1" ]; then
        sed -i 's/ENABLED=.*/ENABLED=0/' "$CONFIG_FILE"
        echo "Wi-Fi ADB 已关闭"
    else
        sed -i 's/ENABLED=.*/ENABLED=1/' "$CONFIG_FILE"
        echo "Wi-Fi ADB 已开启"
    fi
fi
