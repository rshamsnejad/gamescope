#!/bin/bash
#retreving prebuilt binary
sudo curl -O ~/gamescope.zip https://github.com/ruineka/gamescope-onexplayer/files/9056679/gamescope.zip
sudo unzip ~/gamescope.zip -d /usr/bin
#Cleanup
sudo rm ~/gamescope.zip

#grabbing HandyGCCS
git clone https://github.com/ShadowBlip/HandyGCCS.git ~/HandyGCCS
cd ~/HandyGCCS
sudo make install

#switching to gamepadui
chimera-session gamepadui

