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

echo "------------ DEBUT Firefox -----------------"
# Install Firefox and its dependencies
# https://support.mozilla.org/en-US/kb/install-firefox-linux
# https://www.mozilla.org/en-US/firefox/117.0/system-requirements/
RUN install -d -m 0755 /etc/apt/keyrings && \
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null && \
    gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}' && \
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null && \
    echo 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000' | tee /etc/apt/preferences.d/mozilla && \
    apt-get update && apt-get install -y --no-install-recommends \
        libpci-dev \
        libcanberra-gtk3-module \
        libgles2-mesa-dev \
        dbus-x11 \
        firefox-esr && \
    apt-get clean
echo "------------ FIN Firefox -----------------"

/usr/local/bin/layer-cleanup.sh

echo "------------ DEBUT others -----------------"
apt-get update --quiet
apt-get install --yes --quiet --no-install-recommends \
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

echo "------------ FIN others -----------------"

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
