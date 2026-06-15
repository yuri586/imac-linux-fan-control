#!/usr/bin/env bash

set -u

FAN_PATH="/sys/devices/platform/applesmc.768"

echo "=== iMac Linux Fan Control environment check ==="
echo

OK=1

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "OK: command '$1' found"
    else
        echo "ERROR: command '$1' not found"
        OK=0
    fi
}

check_file() {
    if [[ -e "$1" ]]; then
        echo "OK: found $1"
    else
        echo "ERROR: missing $1"
        OK=0
    fi
}

echo "--- Commands ---"
check_command sensors

echo
echo "--- Kernel modules / sensor output ---"
if command -v sensors >/dev/null 2>&1; then
    if sensors | grep -q "coretemp"; then
        echo "OK: coretemp sensor detected"
    else
        echo "WARNING: coretemp sensor not found in sensors output"
        OK=0
    fi

    if sensors | grep -q "applesmc"; then
        echo "OK: applesmc sensor detected"
    else
        echo "WARNING: applesmc sensor not found in sensors output"
        OK=0
    fi

    if sensors | grep -q "Package id 0"; then
        echo "OK: CPU temperature label 'Package id 0' found"
    else
        echo "WARNING: CPU label 'Package id 0' not found"
        OK=0
    fi

    if sensors | grep -q "TG0H"; then
        echo "OK: GPU temperature label 'TG0H' found"
    else
        echo "WARNING: GPU label 'TG0H' not found"
        OK=0
    fi
fi

echo
echo "--- Fan control paths ---"
check_file "$FAN_PATH/fan1_manual"
check_file "$FAN_PATH/fan1_output"
check_file "$FAN_PATH/fan1_input"

check_file "$FAN_PATH/fan2_manual"
check_file "$FAN_PATH/fan2_output"
check_file "$FAN_PATH/fan2_input"

check_file "$FAN_PATH/fan3_manual"
check_file "$FAN_PATH/fan3_output"
check_file "$FAN_PATH/fan3_input"

echo
if [[ "$OK" -eq 1 ]]; then
    echo "RESULT: environment looks compatible."
    echo "You can continue with:"
    echo "  sudo ./scripts/install.sh"
    exit 0
else
    echo "RESULT: environment is not ready."
    echo
    echo "Try:"
    echo "  sudo apt install lm-sensors"
    echo "  sudo sensors-detect"
    echo "  sudo modprobe applesmc"
    echo
    echo "Then run this check again:"
    echo "  ./scripts/check_environment.sh"
    exit 1
fi
