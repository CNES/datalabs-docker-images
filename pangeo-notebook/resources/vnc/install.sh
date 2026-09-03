#!/bin/bash
# Copyright 2024 CS GROUP - https://www.csgroup.eu
# Copyright 2024 CNES - https://cnes.fr
# All rights reserved
# This file is provided under MIT license. See LICENSE file.
set -e

# noVNC setup
# See also:
# * https://github.com/manics/jupyter-omeroanalysis-desktop
# * https://github.com/ml-tooling/ml-workspace

# COPY /resources/vnc /opt
mv resources/vnc/start-notebook-genvnctoken.sh /usr/local/bin/
chmod +x /usr/local/bin/start-notebook-genvnctoken.sh
cp resources/vnc/* /opt

# Customize Desktop
mkdir -p /opt/vre/


#add-apt-repository ppa:mozillateam/ppa --yes
#apt-get update --quiet
#DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends firefox-esr 

#FIRFOX-ESR
install -d -m 0755 /etc/apt/keyrings
#Import the Mozilla APT repository signing key:
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
#Next, add the Mozilla APT repository to your sources.list:
#For Debian Trixie/Ubuntu Resolute and Newer 
tee /etc/apt/sources.list.d/mozilla.sources > /dev/null << EOF
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc
EOF
#Configure APT to prioritize packages from the Mozilla repository:
tee /etc/apt/preferences.d/mozilla > /dev/null << EOF
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF
#For Ubuntu users: If you want to replace the snap version of firefox to the deb version, you need to pin the firefox snap version from the APT package manager before removing the snap package with sudo snap remove firefox command to prevent unwanted upgrades to the snap version of firefox. 
tee /etc/apt/preferences.d/mozilla > /dev/null << EOF
Package: firefox
Pin: release o=Ubuntu
Pin-Priority: -1
EOF
#Update your package list, and install firefox (or one of firefox-esr, -beta, -nightly, -devedition):
apt-get update --quiet
apt-get install firefox-esr --yes --quiet 

./usr/local/bin/layer-cleanup.sh

apt-get update --quiet
DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
    dconf-cli \
    dbus-x11 \
    evince \
    file-roller \
    geeqie \
    thunar-archive-plugin \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg \
    xubuntu-icon-theme


curl -sSfL https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar -zxf - -C /opt
mv /opt/noVNC-1.4.0 /opt/noVNC
# Fix VNC client
chmod o+r /opt/vnc.html
chmod o+r /opt/ui.js
mv /opt/vnc.html /opt/noVNC
mv /opt/ui.js /opt/noVNC/app
wget 'https://sourceforge.net/projects/turbovnc/files/3.1/turbovnc_3.1_amd64.deb/download' -O turbovnc_3.1_amd64.deb
apt-get install -y -q ./turbovnc_3.1_amd64.deb
rm ./turbovnc_3.1_amd64.deb
ln -s /opt/TurboVNC/bin/* /usr/local/bin/
mamba install --quiet websockify
cp resources/branding/desktop/wallpaper.png /opt/vre/wallpaper.png
cp -r resources/branding/desktop/xfce-perchannel-xml /etc/xdg/xfce4/xfconf/
# Fix missing rebind.so issue
cd /opt && git clone --quiet https://github.com/novnc/websockify.git
cd /opt/websockify && make && cp rebind.so /usr/local/bin
# Remove mail and logout desktop icons
rm /usr/share/applications/xfce4-session-logout.desktop
apt purge --quiet --yes xfce4-screensaver
# Remove lite client as the full client is the one being used in the Desktop Launcher
rm /opt/noVNC/vnc_lite.html
# Avoid creation of default folders
sed -i 's/^#*/#/' /etc/xdg/user-dirs.defaults
sed -i 's/enabled=True/enabled=False/' /etc/xdg/user-dirs.conf

chmod 664 /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/*
