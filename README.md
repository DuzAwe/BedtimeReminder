# KDE Bedtime
I built this quickly....maybe to quickly.

Its plays a random audio file and shows a desktop notification on KDE (or any Linux desktop with `notify-send` and PulseAudio/PipeWire). 

## Why
I needed something to remind me to go to bed. I dont always see the desktop clock, I keep my phone face down after work, And other reasons. 

Why put this on github. It backs it up and might be something someone else can use. 

## What it does
- Picks a random `.ogg`, `.mp3`, or `.wav` from a folder.
- Shows a notification with the file name.
- Plays the audio with `paplay`.

## Requirements
- `notify-send` (usually in `libnotify-bin`)
- PulseAudio or PipeWire with `paplay`
- Audio files in a directory you control

## Setup
1. Edit the script and set your username and audio directory:

   ```bash
   USER_NAME="your_username"
   AUDIO_DIR="/path/to/your/audio/files"
   ```

2. Make the script executable:

   ```bash
   chmod +x KDEBedtime.sh
   ```

## Run
```bash
./KDEBedtime.sh
```

## Notes
- This is Wayland-friendly and uses `XDG_RUNTIME_DIR` and the user D-Bus socket instead of Xorg variables.
- It works best as a systemd **user** service or when run from your logged-in session.
- If you are not logged in, the user runtime directory and session bus are not available, so notifications and audio will fail.

## Troubleshooting
- "No audio files found": double-check `AUDIO_DIR` and file extensions.
- Notifications not showing: verify `notify-send` is installed and your `DBUS_SESSION_BUS_ADDRESS` and `XDG_RUNTIME_DIR` are correct.
- Audio not playing: confirm `paplay` works from your terminal and that your audio server is running.
