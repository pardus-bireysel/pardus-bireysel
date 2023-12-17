#!/bin/bash

# 2023 🄯 Pardus Bireysel Contributors
# https://github.com/pardus-bireysel/pardus-bireysel

### Remove unnecessary applications from system ###

# REVIEW Shellcheck / Bash IDE extensions is not working when sourcing from another dir
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$DIR/../common.sh"

#removes app with package name
_remove() {
  _log "Uygulama siliniyor: $1" v
  sudo apt purge "$1" -y

  # TODO turn off apt logs if dev mode not enabled!

  # TODO Uygulamayı silmeden önce uygulamanın olup olmadığı kontrol edilebilir

  # FIXME error handling, uygulama silme işlemi hata verirse veya kabuk hata kodu dönerse kullanıcı bilgilendirilmeli

  _log "Uygulama silindi: $1" ok
}

# SEE https://tracker.pardus.org.tr/ for packages
COMMON_APPS=("gimp" "icedtea-netx" "audacious" "firefox-esr" "libreoffice")
XFCE_APPS=("thunar" "mousepad" "ristretto" "xfburn"
  "xfce4" "xfce4-sensors-plugin"
  # "pardus-xfce-desktop"
  # "pardus-xfce-greeter"
  # "pardus-xfce-gtk-theme"
  # "pardus-xfce-icon-theme"
  # "pardus-xfce-icon-theme-metal" # only in Pardus 19
  # "pardus-xfce-live-settings"
  # "pardus-xfce-settings"
  # "pardus-xfce-tweaks"
  "pardus-xfce*"
)
GNOME_APPS=("nautilus" "gedit" "brasero"
  "malcontent" "malcontent-gui"
  # "pardus-gnome-desktop"
  # "pardus-gnome-greeter"
  # "pardus-gnome-settings"
  # "pardus-gnome-shortcuts"
  "pardus-gnome*"
  "gnome-shell-extension-arc-menu"
  "gnome-desktop3-data"
  "gdm"
  "gdm3"
)

_logconf "DESKTOP_ENVIRONMENT" i

for item in "${COMMON_APPS[@]}"; do
  _remove "$item"
done

if [[ $(_gc "DESKTOP_ENVIRONMENT") != "xfce" ]]; then
  for item in "${XFCE_APPS[@]}"; do
    _remove "$item"
  done
fi

if [[ $(_gc "DESKTOP_ENVIRONMENT") != "gnome" ]]; then
  for item in "${GNOME_APPS[@]}"; do
    _remove "$item"
  done
fi

sudo apt autoremove -y 
sudo apt clean -y 
sudo apt autoclean -y 