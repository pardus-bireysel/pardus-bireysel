#!/bin/bash

# 2023 🄯 Pardus Bireysel Contributors
# https://github.com/pardus-bireysel/pardus-bireysel

#                 #
### COLOR CODES ###
#                 #
# RED='\033[0;31m'
GREEN='\033[0;32m'
# ORANGE='\033[0;33m'
CYAN='\033[0;36m'
# GRAY='\033[0;37m \e[3m'
NC='\033[0m \e[0m' # No Color, No Effect
# BOLD='\033[1;97m'

_start() {
  echo -e "${CYAN}[ i ] Removing package:${NC}$1"
}
_done() {
  echo -e "${GREEN}[ ✔ ] Successfully removed package:${NC}$1"
}

#removes app with package name
_remove() {
  _start "$1"
  sudo apt purge "$1"
  _done "$1"
}

APPS_TO_BE_REMOVED=("gimp" "icedtea-netx")

for item in "${APPS_TO_BE_REMOVED[@]}"
do
    _remove "$item"
done

# TODO Uygulamayı silmeden önce uygulamanın olup olmadığı kontrol edilebilir
# TODO error handling, silme işlemi hata verirse veya kabuk hata kodu dönerse kullanıcı bilgilendirilmeli
# TODO çok fazla yazı gözükmemesi adına _start komutu verbose değişkenine bağlanabilir, varsayılan olarak gizlenir