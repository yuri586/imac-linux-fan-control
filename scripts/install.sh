#!/usr/bin/env bash

set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
echo "Run as root: sudo ./scripts/install.sh" >&2
exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
USER_HOME="${SUDO_USER:+/home/$SUDO_USER}"

install -m 755 "$REPO_DIR/scripts/imac-custom-fan-control.sh" /usr/local/bin/imac-custom-fan-control.sh
install -m 644 "$REPO_DIR/systemd/imac-custom-fan-control.service" /etc/systemd/system/imac-custom-fan-control.service
install -m 644 "$REPO_DIR/systemd/imac-fan-resume.service" /etc/systemd/system/imac-fan-resume.service

if [[ -n "${SUDO_USER:-}" && -d "$USER_HOME" ]]; then
install -d -m 755 "$USER_HOME/.local/bin"
install -m 755 "$REPO_DIR/scripts/show_temps.sh" "$USER_HOME/.local/bin/show_temps.sh"
chown "$SUDO_USER:$SUDO_USER" "$USER_HOME/.local/bin/show_temps.sh"
fi

systemctl daemon-reload
systemctl enable --now imac-custom-fan-control.service
systemctl enable imac-fan-resume.service

echo "Installed."
echo
echo "Check:"
echo "  systemctl status imac-custom-fan-control.service"
echo "  systemctl status imac-fan-resume.service"
echo
echo "Dashboard:"
echo "  ~/.local/bin/show_temps.sh"
echo "  watch -n 5 --exec ~/.local/bin/show_temps.sh"
