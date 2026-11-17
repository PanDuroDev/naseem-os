# start the desktop on the first virtual console
if [ "$(tty)" = "/dev/tty1" ] && [ -e /dev/dri/card0 ]; then
  if command -v start-hyprland >/dev/null 2>&1; then
    exec start-hyprland
  else
    exec Hyprland
  fi
fi