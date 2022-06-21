#!/bin/bash

sudo pacman -Sy ninja meson python3 dbus-python vulkan-headers
git clone -b oxp-90 https://github.com/ruineka/gamescope-onexplayer
cd gamescope-onexplayer
meson build/
ninja -C build/
sudo cp ~/gamescope-onexplayer/build/gamescope /usr/bin

git clone -b service-test https://github.com/shadowblip/handygccs
cd gamescope-onexplayer
cd handygccs
sudo make
reboot
