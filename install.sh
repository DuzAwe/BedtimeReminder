#!/bin/bash

# Bedtime Reminder Installation Script

set -e

echo "Installing Bedtime Reminder Service..."

DEFAULT_BEDTIME="23:00"
read -r -p "Enter your bedtime (HH:MM, 24h) [${DEFAULT_BEDTIME}]: " BEDTIME_INPUT
if [[ -z "${BEDTIME_INPUT}" ]]; then
	BEDTIME_INPUT="${DEFAULT_BEDTIME}"
fi
if [[ "${BEDTIME_INPUT}" =~ ^([01][0-9]|2[0-3]):[0-5][0-9]$ ]]; then
	BEDTIME_TIME="${BEDTIME_INPUT}"
else
	echo "Invalid time format. Using default bedtime ${DEFAULT_BEDTIME}."
	BEDTIME_TIME="${DEFAULT_BEDTIME}"
fi

# Create directories if they don't exist
mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user

SOUNDS_DIR="$HOME/.local/share/bedtime-reminder/Sounds"

USE_BUNDLED_SOUNDS="Y"
read -r -p "Use bundled sounds? [Y/n]: " USE_BUNDLED_SOUNDS

# Copy the main script
echo "Copying script to ~/.local/bin/bedtime-reminder.sh"
cp KDEBedtime.sh ~/.local/bin/bedtime-reminder.sh
chmod +x ~/.local/bin/bedtime-reminder.sh

if [[ -z "${USE_BUNDLED_SOUNDS}" || "${USE_BUNDLED_SOUNDS}" =~ ^[Yy]$ ]]; then
	echo "Installing default sounds to $SOUNDS_DIR"
	mkdir -p "$HOME/.local/share/bedtime-reminder"
	cp -r Sounds "$HOME/.local/share/bedtime-reminder/"
	AUDIO_DIR_TARGET="${SOUNDS_DIR}"
else
	read -r -p "Enter the full path to your audio folder: " CUSTOM_AUDIO_DIR
	if [[ -z "${CUSTOM_AUDIO_DIR}" ]]; then
		echo "No path provided. Using default sounds."
		mkdir -p "$HOME/.local/share/bedtime-reminder"
		cp -r Sounds "$HOME/.local/share/bedtime-reminder/"
		AUDIO_DIR_TARGET="${SOUNDS_DIR}"
	else
		AUDIO_DIR_TARGET="${CUSTOM_AUDIO_DIR}"
	fi
fi

# Auto-configure username and audio dir in the installed script
USER_NAME="$(id -un)"
sed -i "s|^USER_NAME=.*|USER_NAME=\"${USER_NAME}\"|" ~/.local/bin/bedtime-reminder.sh
sed -i "s|^AUDIO_DIR=.*|AUDIO_DIR=\"${AUDIO_DIR_TARGET}\"|" ~/.local/bin/bedtime-reminder.sh

# Copy service and timer files
echo "Installing systemd service and timer..."
cp bedtime-reminder.service ~/.config/systemd/user/
cp bedtime-reminder.timer ~/.config/systemd/user/
sed -i "s|^OnCalendar=.*|OnCalendar=*-*-* ${BEDTIME_TIME}:00|" ~/.config/systemd/user/bedtime-reminder.timer

# Reload systemd daemon
echo "Reloading systemd user daemon..."
systemctl --user daemon-reload

# Ensure the service is not enabled on login
systemctl --user disable --now bedtime-reminder.service 2>/dev/null || true

# Enable the timer
echo "Enabling bedtime reminder timer..."
systemctl --user enable bedtime-reminder.timer

# Start the timer
echo "Starting bedtime reminder timer..."
systemctl --user start bedtime-reminder.timer

echo ""
echo "✓ Installation complete!"
echo ""
echo "The bedtime reminder is now scheduled to run at ${BEDTIME_TIME} every day."
echo "AUDIO_DIR is set to: ${AUDIO_DIR_TARGET}"
echo ""

# Celebrate installation with a notification and sound
notify-send -u normal "Bedtime Reminder Installed" "Happy Sleeping! Your bedtime reminder is set for ${BEDTIME_TIME}." --icon=dialog-information
if [[ -d "${AUDIO_DIR_TARGET}" ]]; then
	RANDOM_SOUND=$(find "${AUDIO_DIR_TARGET}" -type f \( -name "*.ogg" -o -name "*.mp3" -o -name "*.wav" \) -print0 2>/dev/null | shuf -z -n1 | tr -d '\0')
	if [[ -n "${RANDOM_SOUND}" ]]; then
		paplay "${RANDOM_SOUND}" 2>/dev/null || true
	fi
fi


echo "Useful commands:"
echo "  • Check timer status:    systemctl --user status bedtime-reminder.timer"
echo "  • List all timers:       systemctl --user list-timers"
echo "  • Test manually:         systemctl --user start bedtime-reminder.service"
echo "  • Stop timer:            systemctl --user stop bedtime-reminder.timer"
echo "  • Disable timer:         systemctl --user disable bedtime-reminder.timer"
echo "  • View logs:             journalctl --user -u bedtime-reminder.service"
echo ""
