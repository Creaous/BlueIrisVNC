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