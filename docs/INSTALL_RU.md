
# Установка на iMac 2011 с Linux Mint

Этот проект предназначен для конкретного случая: iMac 2011 на Linux Mint с доступным модулем `applesmc`.

## 1. Проверка датчиков

```bash
sensors
```

Нужны примерно такие датчики:

```text
coretemp-isa-0000
applesmc-isa-0300
```

## 2. Проверка fan-путей

```bash
ls /sys/devices/platform/applesmc.768/fan*
```

Ожидаются файлы:

```text
fan1_manual
fan1_output
fan1_input

fan2_manual
fan2_output
fan2_input

fan3_manual
fan3_output
fan3_input
```

## 3. Установка

```bash
chmod +x scripts/*.sh
sudo ./scripts/install.sh
```

## 4. Проверка служб

```bash
systemctl status imac-custom-fan-control.service
systemctl status imac-fan-resume.service
```

## 5. Дашборд

```bash
~/.local/bin/show_temps.sh
```

Или live-режим:

```bash
watch -n 5 --exec ~/.local/bin/show_temps.sh
```

## 6. Проверка после сна

```bash
systemctl suspend
```

После пробуждения:

```bash
cat /sys/devices/platform/applesmc.768/fan1_manual
cat /sys/devices/platform/applesmc.768/fan2_manual
cat /sys/devices/platform/applesmc.768/fan3_manual
systemctl status imac-custom-fan-control.service
```

Ожидаемый результат для `fan*_manual`:

```text
1
```

## 7. Удаление

```bash
sudo ./scripts/uninstall.sh
```

