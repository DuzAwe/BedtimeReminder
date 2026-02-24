#!/bin/bash

# Set your username
USER_NAME="your_username"

# Set the directory containing your audio files
AUDIO_DIR="/path/to/your/audio/files"

# Wayland/session bus environment
export XDG_RUNTIME_DIR="/run/user/$(id -u ${USER_NAME})"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

# Set the PulseAudio/PipeWire environment
export PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native"

# Function to select a random file from a directory
# Uses null delimiter to handle filenames with spaces
select_random_file() {
    find "$AUDIO_DIR" -type f \( -name "*.ogg" -o -name "*.mp3" -o -name "*.wav" \) -print0 | shuf -z -n1 | tr -d '\0'
}

# Get a random audio file
AUDIO_FILE=$(select_random_file)

# Check if a file was found
if [ -z "$AUDIO_FILE" ]; then
    notify-send "Error" "No audio files found in $AUDIO_DIR"
    exit 1
fi

# Send a critical notification with the filename
notify-send -u critical "Evening Alert" "Playing: $(basename "$AUDIO_FILE")"

# Play the random audio file
paplay "$AUDIO_FILE"
