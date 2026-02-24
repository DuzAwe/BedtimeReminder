#!/bin/bash

# Bedtime Reminder Uninstallation Script

set -e

echo "Uninstalling Bedtime Reminder Service..."

# Stop and disable the timer
echo "Stopping and disabling timer..."
systemctl --user stop bedtime-reminder.timer 2>/dev/null || true
systemctl --user disable bedtime-reminder.timer 2>/dev/null || true

# Remove service and timer files
echo "Removing service files..."
rm -f ~/.config/systemd/user/bedtime-reminder.service
rm -f ~/.config/systemd/user/bedtime-reminder.timer

# Remove the script
echo "Removing script..."
rm -f ~/.local/bin/bedtime-reminder.sh

# Reload systemd daemon
echo "Reloading systemd user daemon..."
systemctl --user daemon-reload

echo ""
echo "✓ Uninstallation complete!"
echo ""
