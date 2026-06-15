#!/usr/bin/env bash

clear

echo "--- Temperatures: ---"
(
sensors | grep "Package id 0" | sed "s/Package id 0:/CPU Package:/" | tr -s " "
sensors | grep "TG0H" | sed "s/TG0H:/GPU Heatsink:/" | tr -s " "
sensors | grep "Tp2H" | sed "s/Tp2H:/Power Sensor:/" | tr -s " "
) | column -t -s ":"

echo
echo "--- Fans RPM: ---"
(
echo "GPU / ODD fan: $(cat /sys/devices/platform/applesmc.768/fan1_input 2>/dev/null || echo N/A)"
echo "HDD / PSU fan: $(cat /sys/devices/platform/applesmc.768/fan2_input 2>/dev/null || echo N/A)"
echo "CPU fan: $(cat /sys/devices/platform/applesmc.768/fan3_input 2>/dev/null || echo N/A)"
) | column -t -s ":"
