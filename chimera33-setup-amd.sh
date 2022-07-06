#!/bin/bash
#retreving prebuilt binary
sudo pacman -S --noconfirm wget
sudo wget -O ~/gamescope.zip https://github.com/ruineka/gamescope-onexplayer/files/9056679/gamescope.zip

#backing up original gamescope
sudo mv /usr/bin/gamescope /usr/bin/gamescope.bak

sudo unzip ~/gamescope.zip -d /usr/bin
#Cleanup
sudo rm ~/gamescope.zip

#grabbing HandyGCCS
git clone https://github.com/ShadowBlip/HandyGCCS.git ~/HandyGCCS
cd ~/HandyGCCS
sudo make install

#switching to gamepadui
chimera-session gamepadui

