#!/bin/bash

# 2023 - 2024 🄯 Pardus Bireysel Contributors
# https://github.com/pardus-bireysel/pardus-bireysel

### Install newer versions of necessary applications ###

# REVIEW Shellcheck / Bash IDE extensions is not working when sourcing from another dir
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$DIR/../common.sh"

#removes app with package name
_install() {
  _log "Uygulama indiriliyor ve yükleniyor: $1" v
  sudo apt install "$1" -y

  # TODO turn off apt logs if dev mode not enabled!

  # TODO Uygulamayı silmeden önce uygulamanın olup olmadığı kontrol edilebilir

  # FIXME error handling, uygulama silme işlemi hata verirse veya kabuk hata kodu dönerse kullanıcı bilgilendirilmeli

  _log "Uygulama yüklendi: $1" ok
}

# SEE https://tracker.pardus.org.tr/ for packages
ESSENTIAL_APPS=("kwin-x11" "kwin" "dolphin")
APPS=("firefox")


for item in ${ESSENTIAL_APPS[@]}"; do 
    _install "$item"
done

for item in "${APPS[@]}"; do 
  _log "${item} uygulamasını yüklemek ister misiniz?" warn
    if _checkanswer 1; then
      _install "$item"
    fi
done