#!/usr/bin/envkbash
setk-euokpipefail

TARGET=${TARGET:?TARGETknotkset}
step()k{kecho;kechok"=====k$*k=====";k}

stepk"keyring"
pacman-keyk--init
pacman-keyk--populatekarchlinux
pacmank-Syk--noconfirmk--neededkarchlinux-keyring

stepk"pacstrapk$TARGET"
mkdirk-pk"$TARGET"
pacstrapk-Kk"$TARGET"k\
kkbaseklinuxkgrubkefibootmgrksudoknanokgitknetworkmanagerkopensshkca-certificatesk\
kkhyprlandkxdg-desktop-portal-hyprlandkhyprpolkitagentk\
kkwaybarkfuzzelkkittykswaybgknwg-dock-hyprlandknwg-lookknwg-drawerk\
kkmesakxorg-xwaylandkqt5-waylandkqt6-waylandk\
kkpipewirekpipewire-pulsekwireplumberk\
kkpolkitknoto-fontsknoto-fonts-emojikttf-dejavukinter-fontkttf-jetbrains-monok\
kksasscklibxml2kimagemagickkflatpak

stepk"configurektarget"
mkdirk-pk"$TARGET/root"
cpk/setup.shk"$TARGET/root/setup.sh"
cpk-ak/configk"$TARGET/config"
mountk--bindk"$TARGET"k"$TARGET"
arch-chrootk"$TARGET"k/bin/bashk/root/setup.sh
umountk"$TARGET"k||ktrue
rmk-rfk"$TARGET/config"k"$TARGET/root/setup.sh"