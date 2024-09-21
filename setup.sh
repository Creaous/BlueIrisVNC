#!/bin/bash

read -p "Are you sure you want to run this script? [Y/n] " -n 1 -r REPLY
REPLY=${REPLY:-Y}
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Running script..."
else
    echo "Exiting script..."
    exit 1
fi

# check if there is a previous configuration
if [ -d /home/viewer ]; then
    read -p "There is a previous configuration. Do you want to remove it? (We won't continue otherwise) [Y/n] " -n 1 -r REPLY
    REPLY=${REPLY:-Y}
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Removing previous configuration..."
        # remove previous configuration
        sudo pkill -u viewer
        sudo userdel --remove viewer
        sudo rm -rf /home/viewer
    else
        echo "Exiting script..."
        exit 1
    fi
fi

# new configuration
echo "Creating new configuration..."
cd /tmp
git clone https://github.com/Creaous/BlueIrisVNC.git /tmp/bivnc
sudo apt-get install git wait-for-it tigervnc-viewer feh xorg sddm
sudo useradd viewer
sudo mkdir -p /home/viewer/.vnc
sudo mkdir -p /home/viewer/.config/i3
sudo cp -r /tmp/bivnc/home/viewer/* /home/viewer
sudo cp -r /tmp/bivnc/home/viewer/.config/i3/* /home/viewer/.config/i3
sudo cp -r /tmp/bivnc/etc/sddm.conf.d/* /etc/sddm.conf.d
sudo chmod -R 755 /home/viewer
sudo chown -R viewer:viewer /home/viewer
sudo chmod 700 /home/viewer/start.sh
sudo chmod +x /home/viewer/start.sh

# configure ip address
read -p "Please enter the IP address to configure (default is 127.0.0.1): " IP_ADDRESS
IP_ADDRESS=${IP_ADDRESS:-127.0.0.1}
sudo sed -i "s/127.0.0.1/$IP_ADDRESS/" /home/viewer/start.sh

echo The script *should* be finished now.

read -p "Would you like to reboot your system? [Y/n] " -n 1 -r REPLY
REPLY=${REPLY:-Y}
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo reboot
else
    echo "Exiting script..."
    exit 1
fi