#!/bin/bash

# Change 127.0.0.1 to your VNC server IP address.
HOST=${1:-${VNC_HOST:-127.0.0.1}}

while true; do
    wait-for-it --timeout=0 -h "$HOST" -p 5900
    xtigervncviewer -Shared -FullScreen -FullscreenSystemKeys -CompressLevel 0 -QualityLevel 9 -PreferredEncoding raw -AlertOnFatalError 0 -ReconnectOnError 0 -PasswordFile /home/viewer/.vnc/passwd "$HOST"

    if [ $? -ne 0 ]; then
        echo "Connection to $HOST failed. Retrying in 5 seconds..."
        sleep 5
    fi
done
