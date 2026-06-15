# iMac Linux Fan Control

Custom fan control and temperature dashboard for **iMac 2011 running Linux Mint**.

This project contains a small set of Bash/systemd tools that solve a real hardware problem: manual fan control on an older iMac after installing Linux.

## Portfolio value

This repository demonstrates practical Linux automation:

- working with hardware sensors;
- writing safe Bash scripts;
- installing and managing systemd services;
- documenting a real maintenance task;
- solving a real problem on old hardware after switching to Linux.

## What it does

- Enables manual fan control through `applesmc`
- Controls CPU and GPU-related fan speeds based on temperature
- Keeps HDD/PSU airflow at a fixed safe baseline
- Provides a small terminal dashboard for temperatures and fan RPM
- Installs a systemd service for automatic startup
- Restores fan control after suspend/resume

## Why this project exists

After installing Linux Mint on an iMac 2011, default fan behavior may not be optimal.  
This project is a practical hardware-specific solution for keeping the machine cooler and easier to monitor.

It is not a universal fan-control package.  
It is a documented, real-world Linux automation example for one specific machine.

## Target machine

Tested hardware:

- Apple iMac 27-inch, Mid 2011
- Model Identifier: `iMac12,2`
- Board ID: `Mac-942B59F58194171B`
- Linux Mint
- `applesmc` kernel module
- `lm-sensors`

This project was tested on the exact machine above.  
It may work on similar iMac models, but sensor names and fan paths can be different.

You can check your model on Linux with:

```bash
cat /sys/devices/virtual/dmi/id/product_name
cat /sys/devices/virtual/dmi/id/board_name
inxi -M
```

Expected fan paths:

```text
/sys/devices/platform/applesmc.768/fan1_*
/sys/devices/platform/applesmc.768/fan2_*
/sys/devices/platform/applesmc.768/fan3_*
```

## Before installation

This project depends on Linux hardware sensors.

The scripts do not create sensors by themselves.  
They expect that Linux already exposes CPU/GPU temperature sensors and fan control files.

Install sensor tools first:

```bash
sudo apt update
sudo apt install lm-sensors
```

Detect available sensors:

```bash
sudo sensors-detect
```

On iMac hardware, the `applesmc` module may also be needed:

```bash
sudo modprobe applesmc
```

Check sensor output:

```bash
sensors
```

This project expects to find:

```text
coretemp-isa-0000
applesmc-isa-0300
Package id 0
TG0H
```

It also expects fan control files here:

```text
/sys/devices/platform/applesmc.768/fan1_manual
/sys/devices/platform/applesmc.768/fan1_output
/sys/devices/platform/applesmc.768/fan1_input

/sys/devices/platform/applesmc.768/fan2_manual
/sys/devices/platform/applesmc.768/fan2_output
/sys/devices/platform/applesmc.768/fan2_input

/sys/devices/platform/applesmc.768/fan3_manual
/sys/devices/platform/applesmc.768/fan3_output
/sys/devices/platform/applesmc.768/fan3_input
```

Run the environment check before installation:

```bash
chmod +x scripts/*.sh
./scripts/check_environment.sh
```

If the check passes, install the fan control service:

```bash
sudo ./scripts/install.sh
```

## Repository structure

```text
.
├── scripts/
│   ├── imac-custom-fan-control.sh
│   ├── show_temps.sh
│   ├── check_environment.sh
│   ├── install.sh
│   └── uninstall.sh
├── systemd/
│   ├── imac-custom-fan-control.service
│   └── imac-fan-resume.service
├── docs/
│   └── INSTALL_RU.md
├── README.md
└── LICENSE
```

## Installation

```bash
git clone https://github.com/yuri586/imac-linux-fan-control.git
cd imac-linux-fan-control

chmod +x scripts/*.sh
./scripts/check_environment.sh
sudo ./scripts/install.sh
```

## Check status

```bash
systemctl status imac-custom-fan-control.service
systemctl status imac-fan-resume.service
```

## Open dashboard

```bash
~/.local/bin/show_temps.sh
```

Or run it live:

```bash
watch -n 5 --exec ~/.local/bin/show_temps.sh
```

## Uninstall

```bash
sudo ./scripts/uninstall.sh
```

## Warning

This project directly controls hardware fans through Linux sysfs.

Use it only if you understand what it does and have checked that your sensor names and fan paths match your machine.

Wrong fan settings may lead to overheating.

## Skills shown

* Bash scripting
* Linux hardware diagnostics
* `lm-sensors`
* `applesmc`
* sysfs
* systemd services
* suspend/resume hooks
* practical automation
* documentation for a real maintenance task
