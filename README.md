# KDE Bedtime
I built this quickly....maybe too quickly.

It plays a random audio file and shows a desktop notification on KDE (or any Linux desktop with `notify-send` and PulseAudio/PipeWire). 

## Why
I needed something to remind me to go to bed. I don't always see the desktop clock, I keep my phone face down after work, and other reasons. 

Why put this on GitHub? It backs it up and might be something someone else can use. 

## What it does
- Picks a random `.ogg`, `.mp3`, or `.wav` from a folder.
- Shows a notification with the file name.
- Plays the audio with `paplay`.
- Can be installed as a systemd user service to run automatically at a scheduled time.

## Requirements
- `notify-send` (usually in `libnotify-bin`)
- PulseAudio or PipeWire with `paplay`
- Audio files in a directory you control

## Setup

### Quick Installation (Recommended)
1. Edit `KDEBedtime.sh` and set your username and audio directory:

   ```bash
   USER_NAME="your_username"
   AUDIO_DIR="/path/to/your/audio/files"
   ```

2. Run the installation script:

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

   This will:
   - Copy the script to `~/.local/bin/bedtime-reminder.sh`
   - Install systemd service and timer files
   - Enable and start the timer (default: runs at 10:00 PM daily)

3. To customize the schedule, edit `~/.config/systemd/user/bedtime-reminder.timer` and change the `OnCalendar` value, then run:

   ```bash
   systemctl --user daemon-reload
   systemctl --user restart bedtime-reminder.timer
   ```

### Manual Setup
1. Edit `KDEBedtime.sh` and set your username and audio directory:

   ```bash
   USER_NAME="your_username"
   AUDIO_DIR="/path/to/your/audio/files"
   ```

2. Make the script executable:

   ```bash
   chmod +x KDEBedtime.sh
   ```

## Usage

### As a Service
Once installed, the timer runs automatically. Useful commands:

```bash
# Check timer status
systemctl --user status bedtime-reminder.timer

# List all active timers
systemctl --user list-timers

# Test the service manually
systemctl --user start bedtime-reminder.service

# View logs
journalctl --user -u bedtime-reminder.service

# Stop the timer
systemctl --user stop bedtime-reminder.timer

# Disable the timer (won't start on login)
systemctl --user disable bedtime-reminder.timer
```

### Manual Run
```bash
./KDEBedtime.sh
```

## Uninstall
To remove the service:

```bash
./uninstall.sh
```

## Notes
- This is Wayland-friendly and uses `XDG_RUNTIME_DIR` and the user D-Bus socket instead of Xorg variables.
- It works best as a systemd **user** service or when run from your logged-in session.
- If you are not logged in, the user runtime directory and session bus are not available, so notifications and audio will fail.
 - The timer uses `Persistent=false` by default so it will **not** fire on login to catch up after a missed schedule. If you want catch-up behavior, set it to `true`.

## Troubleshooting
- "No audio files found": double-check `AUDIO_DIR` and file extensions.
- Notifications not showing: verify `notify-send` is installed and your `DBUS_SESSION_BUS_ADDRESS` and `XDG_RUNTIME_DIR` are correct.
- Audio not playing: confirm `paplay` works from your terminal and that your audio server is running.
