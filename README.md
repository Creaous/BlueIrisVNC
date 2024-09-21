# Blue Iris VNC

A collection of scripts and configurations for my VNC setup.

Scripts were made with `Ubuntu 24.04.1 LTS` and `TigerVNC Viewer v1.13.1` in mind.

## What does it do?

It will install the following:

- Git
- Wait-for-it
- TigerVNC Viewer
- Feh
- Xorg
- Sddm

It will also create a new user called `viewer` and create a new configuration for it.

The configuration will be located in `/home/viewer` and will have the following:

- A VNC password
- A start script
- A configuration for i3

Additionally, an `autologin.conf` file will be created in `/etc/sddm.conf.d` to automatically log in the user.

The start script will be located in `/home/viewer/start.sh` and will start the VNC viewer with the following options:

- `-Shared`: Share the VNC server with other users
- `-FullScreen`: Start in full screen mode
- `-FullscreenSystemKeys`: Use the system keys for fullscreen mode
- `-CompressLevel 0`: Disable compression
- `-QualityLevel 9`: Set the quality level to 9
- `-PreferredEncoding raw`: Use raw encoding
- `-AlertOnFatalError 0`: Disable alert on fatal error
- `-ReconnectOnError 0`: Disable reconnection on error
- `-PasswordFile /home/viewer/.vnc/passwd`: Use the VNC password file
- `$HOST`: Use the IP address provided by the user

It has host checking functionality to make sure the VNC server is up before starting the VNC viewer and has a reconnect feature to make sure the VNC viewer is connected to the server after a server reboot.

### In short...

It will create a new user that will auto login and connect to a VNC server with reconnection functionality (like surviving Blue Iris reboots or a case where the VNC viewer starts before the VNC server).

## What server and client are used?

Server uses: **UltraVNC Server**

Client uses: **TigerVNC Viewer**

## How can I use it?

Use `source <(curl -L https://raw.githubusercontent.com/Creaous/BlueIrisVNC/main/setup.sh)`.
