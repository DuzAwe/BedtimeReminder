# Bedtime Reminder
I built this quickly....maybe too quickly.

It plays a random audio file and shows a desktop notification on KDE (or any Linux desktop with `notify-send` and PulseAudio/PipeWire). 

## Why
I needed something to remind me to go to bed. I don't always see the desktop clock, I keep my phone face down after work, and other reasons. 

Why put this on GitHub? It backs it up and might be something someone else can use. 

## What it does
- Picks a random `.ogg`, `.mp3`, or `.wav` from a folder.
- Shows a critical notification with the file name (bypasses Do Not Disturb).
- Plays the audio with `paplay`.
- Can be installed as a systemd user service to run automatically at a scheduled time.

## Requirements
- `notify-send` (usually in `libnotify-bin`)
- PulseAudio or PipeWire with `paplay`
- Audio files in a directory you control

## Setup

### Quick Installation (Recommended)
1. Run the installation script:

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

   This will:
   - Copy the script to `~/.local/bin/bedtime-reminder.sh`
   - Copy bundled sounds to `~/.local/share/bedtime-reminder/Sounds`
   - Auto-configure your username and the default audio directory
   - Prompt for your bedtime and whether to use bundled sounds
   - Set `AUDIO_DIR` and install systemd service and timer files
   - Enable and start the timer at your chosen time (defaults to 23:00)
   - Play a test notification and sound to confirm everything works once installed

2. To customize the schedule later, edit `~/.config/systemd/user/bedtime-reminder.timer` and change the `OnCalendar` value, then run:

   ```bash
   systemctl --user daemon-reload
   systemctl --user restart bedtime-reminder.timer
   ```

### Manual Setup
1. Edit `KDEBedtime.sh` and set your username and audio directory (required for manual setup):

   ```bash
   USER_NAME="your_username"
   AUDIO_DIR="/path/to/your/audio/files"
   ```

2. Make the script executable:

   ```bash
   chmod +x KDEBedtime.sh
   ```

3. If you want the bundled sounds, copy them and set `AUDIO_DIR` to match:

   ```bash
   mkdir -p ~/.local/share/bedtime-reminder
   cp -r Sounds ~/.local/share/bedtime-reminder/
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

# If it triggers on login, the service was enabled; disable it
systemctl --user disable --now bedtime-reminder.service
```

### Manual Run
```bash
./KDEBedtime.sh
```

## Using Your Own Sounds
The installer will ask if you want to use bundled sounds or provide your own directory during installation.

If you chose bundled sounds, they're located at:

```
~/.local/share/bedtime-reminder/Sounds
```

To switch to custom audio files after installation:
1. Put your `.ogg`, `.mp3`, or `.wav` files in a folder you control.
2. Edit `~/.local/bin/bedtime-reminder.sh` and set `AUDIO_DIR` to that folder.
3. Restart the timer so the change applies:

   ```bash
   systemctl --user restart bedtime-reminder.timer
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

## Troubleshooting
- "No audio files found": double-check `AUDIO_DIR` and file extensions.
- Notifications not showing: verify `notify-send` is installed and your `DBUS_SESSION_BUS_ADDRESS` and `XDG_RUNTIME_DIR` are correct.
- Audio not playing: confirm `paplay` works from your terminal and that your audio server is running.
- Triggers on login: make sure the service is not enabled and only the timer is enabled.

## License
This project's code is licensed under GPL-3.0. See the [LICENSE](LICENSE) file for details.

**Note:** The bundled sound files in the `Sounds/` directory have separate licenses from third-party sources. See [Sounds/LICENSE](Sounds/LICENSE) for details.

## Acknowledgments
- Quack sound: https://pixabay.com/sound-effects/075176-duck-quack-40345/
- Sound Effect by freesound_community from Pixabay
- Ducktoy: https://quicksounds.com/sound/22456/duck-toy-sound
- Inspiration: https://github.com/elly-code/reminduck
- First bug tester: Chris (Thank you)
