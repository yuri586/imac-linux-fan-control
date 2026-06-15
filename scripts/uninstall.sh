#!/usr/bin/env bash

set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
echo "Run as root: sudo ./scripts/uninstall.sh" >&2
exit 1
fi

systemctl disable --now imac-custom-fan-control.service 2>/dev/null || true
systemctl disable imac-fan-resume.service 2>/dev/null || true

rm -f /etc/systemd/system/imac-custom-fan-control.service
rm -f /etc/systemd/system/imac-fan-resume.service
rm -f /usr/local/bin/imac-custom-fan-control.sh

if [[ -n "${SUDO_USER:-}" ]]; then
rm -f "/home/$SUDO_USER/.local/bin/show_temps.sh"
fi

systemctl daemon-reload

echo "Uninstalled."
