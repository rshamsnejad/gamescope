## Gamescope OneXPlayer and other handhelds

Rotation was tested on a Intel OneXplayer using these parameters:
gamescope -W 2160 -H 1600 -e -- steam -gamepadui -steamos3 -steampal -steamdeck

Distro: ChimeraOS 33

Known issues:
Intel units will need to use the modified 3.9.5 gamescope listed under the gamescope-onexplayer-downgraded branch or gamescope-onexplayer-intel

The touchscreen inputs are not flipped with the display so that will be a seperate thing to sort out.

What hasn't been tested:
AMD OneXPlayers
GPD Win devices

Pop OS 22.04 build dependencies

sudo apt install libx11-dev libwayland-dev libxkbcommon-dev cmake meson libxdamage-dev libxrender-dev libxtst-dev libvulkan-dev libxcb-xinput-dev libxcb-composite0-dev libxcb-icccm4-dev libxcb-res0-dev libxcb-util-dev libxcomposite-dev libxxf86vm-dev libxres-dev libdrm-dev wayland-protocols libcap-dev libsdl2-dev libgbm-dev libpixman-1-dev libinput-dev libseat-dev seatd libsystemd-dev glslang-tools

Arch Linux

sudo pacman -Sy  gcc-libs glibc libcap.so=2-64 libdrm libliftoff.so=0-64 libpipewire-0.3.so=0-64 libvulkan.so=1-64 libwlroots.so=10-64 libx11 libxcomposite libxdamage libxext libxkbcommon.so=0-64 libxrender libxres libxtst libxxf86vm sdl2 vulkan-icd-loader wayland wayland-protocols wlroots xorg-server-xwayland git glslang meson ninja vulkan-headers


## gamescope: the micro-compositor formerly known as steamcompmgr

In an embedded session usecase, gamescope does the same thing as steamcompmgr, but with less extra copies and latency:

 - It's getting game frames through Wayland by way of Xwayland, so there's no copy within X itself before it gets the frame.
 - It can use DRM/KMS to directly flip game frames to the screen, even when stretching or when notifications are up, removing another copy.
 - When it does need to composite with the GPU, it does so with async Vulkan compute, meaning you get to see your frame quick even if the game already has the GPU busy with the next frame.

It also runs on top of a regular desktop, the 'nested' usecase steamcompmgr didn't support.

 - Because the game is running in its own personal Xwayland sandbox desktop, it can't interfere with your desktop and your desktop can't interfere with it.
 - You can spoof a virtual screen with a desired resolution and refresh rate as the only thing the game sees, and control/resize the output as needed. This can be useful in exotic display configurations like ultrawide or multi-monitor setups that involve rotation.

It runs on Mesa + AMD or Intel, and could be made to run on other Mesa/DRM drivers with minimal work. AMD requires Mesa 20.3+, Intel requires Mesa 21.2+. For NVIDIA's proprietary driver, version 515.43.04+ is required (make sure the `nvidia-drm.modeset=1` kernel parameter is set).

If running RadeonSI clients with older cards (GFX8 and below), currently have to set `R600_DEBUG=nodcc`, or corruption will be observed until the stack picks up DRM modifiers support.

## Building

```
git submodule update --init
meson build/
ninja -C build/

run using: 
build/gamescope -- <game>

```

Install with:

```
meson install -C build/ --skip-subprojects
```
Optional move to /usr/bin
sudo cp /usr/local/bin/gamescope /usr/bin/

## Keyboard shortcuts

* **Super + F** : Toggle fullscreen
* **Super + N** : Toggle integer scaling
* **Super + U** : Toggle FSR upscaling
* **Super + Y** : Toggle NIS upscaling
* **Super + I** : Increase FSR sharpness by 1
* **Super + O** : Decrease FSR sharpness by 1
* **Super + S** : Take screenshot (currently goes to `/tmp/gamescope_$DATE.png`)

## Examples

On any X11 or Wayland desktop, you can set the Steam launch arguments of your game as follows:

```sh
# Upscale a 720p game to 1440p with integer scaling
gamescope -h 720 -H 1440 -n -- %command%

# Limit a vsynced game to 30 FPS
gamescope -r 30 -- %command%

# Run the game at 1080p, but scale output to a fullscreen 3440×1440 pillarboxed ultrawide window
gamescope -w 1920 -h 1080 -W 3440 -H 1440 -b -- %command%
```

## Options

See `gamescope --help` for a full list of options.

* `-W`, `-H`: set the resolution used by gamescope. Resizing the gamescope window will update these settings. Ignored in embedded mode. If `-H` is specified but `-W` isn't, a 16:9 aspect ratio is assumed. Defaults to 1280×720.
* `-w`, `-h`: set the resolution used by the game. If `-h` is specified but `-w` isn't, a 16:9 aspect ratio is assumed. Defaults to the values specified in `-W` and `-H`.
* `-r`: set a frame-rate limit for the game. Specified in frames per second. Defaults to unlimited.
* `-o`: set a frame-rate limit for the game when unfocused. Specified in frames per second. Defaults to unlimited.
* `-U`: use AMD FidelityFX™ Super Resolution 1.0 for upscaling
* `-Y`: use NVIDIA Image Scaling v1.0.2 for upscaling
* `-n`: use integer scaling.
* `-b`: create a border-less window.
* `-f`: create a full-screen window.
