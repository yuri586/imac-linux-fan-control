#!/usr/bin/env bash

# Custom fan control for iMac 2011 on Linux.

# Runs as root through systemd.

# Do not run this on unsupported hardware.

set -u

FAN_PATH="/sys/devices/platform/applesmc.768"

FAN1_MANUAL="$FAN_PATH/fan1_manual"
FAN1_OUTPUT="$FAN_PATH/fan1_output"

FAN2_MANUAL="$FAN_PATH/fan2_manual"
FAN2_OUTPUT="$FAN_PATH/fan2_output"

FAN3_MANUAL="$FAN_PATH/fan3_manual"
FAN3_OUTPUT="$FAN_PATH/fan3_output"

# CPU fan: fan3

CPU_FAN_MIN=940
CPU_FAN_MAX=2600
CPU_TEMP_LOW=55
CPU_TEMP_HIGH=85

# ODD fan: fan1, used here to help cool GPU area

ODD_FAN_MIN=1200
ODD_FAN_MAX=2800
GPU_TEMP_LOW=60
GPU_TEMP_HIGH=85

# HDD fan: fan2

HDD_FIXED_SPEED=1600

SLEEP_SECONDS=5

require_root() {
if [[ "${EUID}" -ne 0 ]]; then
echo "This script must run as root." >&2
exit 1
fi
}

require_paths() {
local paths=(
"$FAN1_MANUAL" "$FAN1_OUTPUT"
"$FAN2_MANUAL" "$FAN2_OUTPUT"
"$FAN3_MANUAL" "$FAN3_OUTPUT"
)

```
for path in "${paths[@]}"; do
    if [[ ! -e "$path" ]]; then
        echo "Missing expected fan control path: $path" >&2
        echo "This machine may not be supported by this script." >&2
        exit 1
    fi
done
```

}

read_cpu_temp() {
sensors coretemp-isa-0000 2>/dev/null 
| awk '/Package id 0/ {
gsub(/+|°C/, "", $4);
split($4, temp, ".");
print temp[1];
exit;
}'
}

read_gpu_temp() {
sensors applesmc-isa-0300 2>/dev/null 
| awk '/TG0H/ {
gsub(/+|°C/, "", $2);
split($2, temp, ".");
print temp[1];
exit;
}'
}

calculate_speed() {
local temp="$1"
local temp_low="$2"
local temp_high="$3"
local fan_min="$4"
local fan_max="$5"

```
if [[ "$temp" -le "$temp_low" ]]; then
    echo "$fan_min"
elif [[ "$temp" -ge "$temp_high" ]]; then
    echo "$fan_max"
else
    local speed_range=$((fan_max - fan_min))
    local temp_range=$((temp_high - temp_low))
    local temp_delta=$((temp - temp_low))

    echo $((fan_min + (temp_delta * speed_range) / temp_range))
fi
```

}

enable_manual_mode() {
echo 1 > "$FAN1_MANUAL"
echo 1 > "$FAN2_MANUAL"
echo 1 > "$FAN3_MANUAL"
}

main() {
require_root
require_paths
enable_manual_mode

```
while true; do
    echo "$HDD_FIXED_SPEED" > "$FAN2_OUTPUT"

    CPU_TEMP="$(read_cpu_temp)"
    GPU_TEMP="$(read_gpu_temp)"

    if [[ "$CPU_TEMP" =~ ^[0-9]+$ ]]; then
        CPU_TARGET_SPEED="$(calculate_speed "$CPU_TEMP" "$CPU_TEMP_LOW" "$CPU_TEMP_HIGH" "$CPU_FAN_MIN" "$CPU_FAN_MAX")"
        echo "$CPU_TARGET_SPEED" > "$FAN3_OUTPUT"
    fi

    if [[ "$GPU_TEMP" =~ ^[0-9]+$ ]]; then
        ODD_TARGET_SPEED="$(calculate_speed "$GPU_TEMP" "$GPU_TEMP_LOW" "$GPU_TEMP_HIGH" "$ODD_FAN_MIN" "$ODD_FAN_MAX")"
        echo "$ODD_TARGET_SPEED" > "$FAN1_OUTPUT"
    fi

    sleep "$SLEEP_SECONDS"
done
```

}

main "$@"
