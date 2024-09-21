#!/bin/bash
cd /tmp
git clone https://github.com/Creaous/BlueIrisVNC.git /tmp/bivnc
sudo apt-get install git wait-for-it tigervnc-viewer feh xorg-server sddm
sudo useradd viewer
sudo mkdir -p /home/viewer/.vnc
sudo mkdir -p /home/viewer/.config/i3
sudo cp -r /tmp/bivnc/home/viewer /home/viewer
sudo cp -r /tmp/bivnc/etc/sddm.conf.d /etc/sddm.conf.d
sudo chmod 700 /home/viewer/start.sh
sudo chmod +x /home/viewer/start.sh
