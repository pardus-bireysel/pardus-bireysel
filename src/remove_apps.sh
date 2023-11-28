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
  echo -e "${CYAN}[ i ] Removing package: ${NC} $1"
}
_done() {
  echo -e "${GREEN}[ ✔ ] Successfully removed package: ${NC} $1"
}

_start "gimp"
sudo apt purge gimp
_done "gimp"

# TODO Uygulamayı silmeden önce uygulamanın olup olmadığı kontrol edilebilir
# TODO error handling, silme işlemi hata verirse veya kabuk hata kodu dönerse kullanıcı bilgilendirilmeli
# TODO çok fazla yazı gözükmemesi adına _start komutu verbose değişkenine bağlanabilir, varsayılan olarak gizlenir
# TODO basit bir komutla tek tek silinmesi gereken uygulamalar için array'e atıp bir for döngüsü açılabilir. Fazla koddan kaçınılmış olur