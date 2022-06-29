#!/bin/bash

sudo pacman -Sy ninja meson python3 dbus-python vulkan-headers
git clone -b oxp-90 https://github.com/ruineka/gamescope-onexplayer
cd gamescope-onexplayer
meson build/
ninja -C build/
sudo meson install -C build/ --skip-subprojects
sudo cp /usr/local/bin/gamescope /usr/bin

git clone https://github.com/ShadowBlip/HandyGCCS.git
cd HandyGCCS
sudo make install
reboot
