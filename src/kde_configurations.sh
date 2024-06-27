#!/bin/bash

# Burada KDE yüklendikten sonra sistem ayarları ve KDE uygulamaları ile ilgili yapılacak çeşitli konfigrasyonlar olacak

# TODO Varsayılan Lightdm DE'si yapmak için lightdm.conf içinde user-session'u "/usr/bin/startplasma-x11" a eşitlemek gerekebilir

# REVIEW Shellcheck / Bash IDE extensions is not working when sourcing from another dir
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$DIR/../common.sh"

_remove_unnecessary_kde_apps() {
  _log "Uygulama siliniyor: $1" v
  sudo apt purge "$1" -y

  # TODO turn off apt logs if dev mode not enabled!

  # TODO Uygulamayı silmeden önce uygulamanın olup olmadığı kontrol edilebilir

  # FIXME error handling, uygulama silme işlemi hata verirse veya kabuk hata kodu dönerse kullanıcı bilgilendirilmeli

  _log "Uygulama silindi: $1" ok
}

APPS_TO_REMOVE=("plasma-discover")

for item in "${APPS_TO_REMOVE[@]}"; do 
  _log "${item} uygulamasını silmek ister misiniz?" warn
    if _checkanswer 1; then
      _remove_unnecessary_kde_apps $item
    fi
done