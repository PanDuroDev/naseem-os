# Naseem: start the desktop on the first virtual terminal when a DRM device exists.
# Without one (headless CI) the shell simply stays available.
if [ "$(tty)" = "/dev/tty1" ] && [ -e /dev/dri/card0 ]; then
  exec Hyprland
fi