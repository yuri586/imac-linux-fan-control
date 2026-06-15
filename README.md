# iMac Linux Fan Control

Custom fan control and temperature dashboard for **iMac 2011 running Linux Mint**.

This project contains a small set of Bash/systemd tools that solve a real hardware problem: manual fan control on an older iMac after installing Linux.

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

Tested on:

- iMac 2011
- Linux Mint
- `applesmc` kernel module
- `lm-sensors`

Expected fan paths:

```text
/sys/devices/platform/applesmc.768/fan1_*
/sys/devices/platform/applesmc.768/fan2_*
/sys/devices/platform/applesmc.768/fan3_*
```

## Repository structure

```text
.
├── scripts/
│   ├── imac-custom-fan-control.sh
│   ├── show_temps.sh
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
