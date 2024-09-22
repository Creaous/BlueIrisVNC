#!/bin/bash

# Prompt user for confirmation before running the script
read -p "Are you sure you want to run this script? [Y/n] " -n 1 -r REPLY
REPLY=${REPLY:-Y}
echo

# Check if user confirms (case-insensitive)
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Running script..."
else
  echo "Exiting script..."
  exit 1
fi

# Check for existing viewer configuration
if [ -d /home/viewer ]; then
  # Prompt user to confirm removal of previous configuration
  read -p "There is a previous configuration. Do you want to remove it? (We won't continue otherwise) [Y/n] " -n 1 -r REPLY
  REPLY=${REPLY:-Y}
  echo

  # Check if user confirms removal (case-insensitive)
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Removing previous configuration..."

    # Stop any running viewer processes
    sudo pkill -u viewer
    sleep 5  # Wait for processes to end

    # Ensure all viewer processes are terminated
    sudo pkill -u viewer
    sleep 5  # Wait for processes to end

    # Delete viewer user and home directory
    sudo userdel --remove viewer
    sudo rm -rf /home/viewer
  else
    echo "Exiting script..."
    exit 1
  fi
fi

# Clone BlueIrisVNC repository for configuration files
echo "Creating new configuration..."
cd /tmp
git clone https://github.com/Creaous/BlueIrisVNC.git /tmp/bivnc

# Install required packages
sudo apt-get install git wait-for-it tigervnc-viewer feh xorg sddm i3

# Create viewer user and directories
sudo useradd viewer
sudo mkdir -p /home/viewer/.vnc
sudo mkdir -p /home/viewer/.config/i3

# Copy configuration files from repository
sudo cp -r /tmp/bivnc/home/viewer/* /home/viewer
sudo cp -r /tmp/bivnc/home/viewer/.config/i3/* /home/viewer/.config/i3
sudo cp -r /tmp/bivnc/etc/sddm.conf.d/* /etc/sddm.conf.d

# Set permissions for viewer user and files
sudo chmod -R 755 /home/viewer
sudo chown -R viewer:viewer /home/viewer
sudo chmod 700 /home/viewer/start.sh
sudo chmod +x /home/viewer/start.sh

# Set VNC password for viewer user
sudo -u viewer vncpasswd

# Disable sleep modes to prevent interruptions
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# Configure IP address for VNC connection (default: 127.0.0.1)
read -p "Please enter the IP address to configure (default is 127.0.0.1): " IP_ADDRESS
IP_ADDRESS=${IP_ADDRESS:-127.0.0.1}
sudo sed -i "s/127.0.0.1/$IP_ADDRESS/" /home/viewer/start.sh

# Script completion message
echo "The script has finished successfully."

# Prompt user for system reboot
read -p "Would you like to reboot your system? [Y/n] " -n 1 -r REPLY
REPLY=${REPLY:-Y}
echo

# Reboot if user confirms
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo reboot
else
  echo "Exiting script..."
  exit 1
fi
