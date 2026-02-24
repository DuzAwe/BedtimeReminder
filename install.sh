#!/bin/bash

# Bedtime Reminder Installation Script

set -e

echo "Installing Bedtime Reminder Service..."

# Create directories if they don't exist
mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user

# Copy the main script
echo "Copying script to ~/.local/bin/bedtime-reminder.sh"
cp KDEBedtime.sh ~/.local/bin/bedtime-reminder.sh
chmod +x ~/.local/bin/bedtime-reminder.sh

# Copy service and timer files
echo "Installing systemd service and timer..."
cp bedtime-reminder.service ~/.config/systemd/user/
cp bedtime-reminder.timer ~/.config/systemd/user/

# Reload systemd daemon
echo "Reloading systemd user daemon..."
systemctl --user daemon-reload

# Enable the timer
echo "Enabling bedtime reminder timer..."
systemctl --user enable bedtime-reminder.timer

# Start the timer
echo "Starting bedtime reminder timer..."
systemctl --user start bedtime-reminder.timer

echo ""
echo "✓ Installation complete!"
echo ""
echo "The bedtime reminder is now scheduled to run at 10:00 PM every day."
echo ""
echo "Useful commands:"
echo "  • Check timer status:    systemctl --user status bedtime-reminder.timer"
echo "  • List all timers:       systemctl --user list-timers"
echo "  • Test manually:         systemctl --user start bedtime-reminder.service"
echo "  • Stop timer:            systemctl --user stop bedtime-reminder.timer"
echo "  • Disable timer:         systemctl --user disable bedtime-reminder.timer"
echo "  • View logs:             journalctl --user -u bedtime-reminder.service"
echo ""
echo "⚠ Remember to edit ~/.local/bin/bedtime-reminder.sh to set:"
echo "  • USER_NAME (your username)"
echo "  • AUDIO_DIR (path to your audio files)"
echo ""
