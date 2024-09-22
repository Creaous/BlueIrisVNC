#!/bin/bash

# Set the VNC host address (default: 127.0.0.1)
HOST=${1:-${VNC_HOST:-127.0.0.1}}

# Continuously attempt to connect to VNC server
while true; do
  # Wait for VNC server to be available (timeout=0: no timeout)
  wait-for-it --timeout=0 -h "$HOST" -p 5900

  # Connect to VNC server using xtigervncviewer
  xtigervncviewer -Shared -FullScreen -FullscreenSystemKeys -CompressLevel 0 -QualityLevel 9 -PreferredEncoding raw -AlertOnFatalError 0 -ReconnectOnError 0 -PasswordFile /home/viewer/.vnc/passwd "$HOST"

  # Check if connection was successful
  if [ $? -ne 0 ]; then
    # Log connection failure and retry after 5 seconds
    echo "Connection to $HOST failed. Retrying in 5 seconds..."
    sleep 5
  fi
done
