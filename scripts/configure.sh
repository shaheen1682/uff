#!/bin/bash
# Reverse Linux VNC for GitHub Actions by PANCHO7532
# This script is executed when GitHub actions is initialized.
# Prepares dependencies, ngrok, and vnc stuff

# First, install required packages...
sudo apt update
sudo apt install -y xfce4 xfce4-goodies xfonts-base xubuntu-icon-theme xubuntu-wallpapers gnome-icon-theme x11-apps x11-common x11-session-utils x11-utils x11-xserver-utils x11-xkb-utils dbus-user-session dbus-x11 gnome-system-monitor gnome-control-center libpam0g libxt6 libxext6

# Second, install TurboVNC
# Fun Fact: TurboVNC is the only VNC implementations that supports OpenGL acceleration without an graphics device by default
# By the way, you can still use the legacy version of this script where instead of installing TurboVNC, tightvncserver is installed.
# Old mirror: wget https://ufpr.dl.sourceforge.net/project/turbovnc/2.2.5/turbovnc_2.2.5_amd64.deb
wget https://phoenixnap.dl.sourceforge.net/project/turbovnc/2.2.5/turbovnc_2.2.5_amd64.deb
sudo dpkg -i turbovnc_2.2.5_amd64.deb

# Third, download ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz
sudo tar -xvzf ngrok-v3-stable-linux-amd64.tgz
chmod +x ngrok

# Fourth, generate and copy passwd file and xstartup script
export PATH=$PATH:/opt/TurboVNC/bin
mkdir $HOME/.vnc
cp ./resources/xstartup $HOME/.vnc/xstartup.turbovnc
echo $VNC_PASSWORD | vncpasswd -f > $HOME/.vnc/passwd
chmod 0600 $HOME/.vnc/passwd

# Fifth and last, set up auth token from argument
#sudo ./ngrok update
#sudo ./ngrok authtoken 23JbfqLdFuwVFwF8u21e4ooV6On_6923mqy5dGNAbqPutzvYb
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./chrome-remote-desktop_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo DEBIAN_FRONTEND=noninteractive \
    sudo apt install --assume-yes xfce4 desktop-base dbus-x11 xscreensaver
sudo bash -c 'echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session'
sudo systemctl disable lightdm.service
DISPLAY= /opt/google/chrome-remote-desktop/start-host --code="4/0AVG7fiQPxR4VxU6bhxG3Fzn1QEb9JI-qphsXzyuyZCnH4yAvTK9xWWRORex1PQF2s_LDnw" --redirect-url="https://remotedesktop.google.com/_/oauthredirect" --name=$(hostname)
exit
