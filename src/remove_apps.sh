#!/bin/bash

# 2023 🄯 Pardus Bireysel Contributors
# https://github.com/pardus-bireysel/pardus-bireysel

### Remove unnecessary applications from system ###

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$DIR/../common.sh"

#removes app with package name
_remove() {
  _log "$1" verbose
  sudo apt purge "$1" -y
  _log "$1" ok
}

APPS_TO_BE_REMOVED=("gimp" "icedtea-netx" "thunar" "mousepad")
KEEP_APPS_IN_XFCE=("thunar" "mousepad")

for item in "${APPS_TO_BE_REMOVED[@]}"; do
  _remove "$item"
done

_log "$DESKTOP_ENVIRONMENT" verbose
## FIXME !!! DESKTOP_ENVRONMENT gets defaults value back after common.sh sourced again in 9th line
## Possible solution1: use config file (read/write)
## Possible solution2: Move changeble variable to another file and try to make it wirt export variables

# TODO Uygulamayı silmeden önce uygulamanın olup olmadığı kontrol edilebilir
# TODO error handling, silme işlemi hata verirse veya kabuk hata kodu dönerse kullanıcı bilgilendirilmeli
