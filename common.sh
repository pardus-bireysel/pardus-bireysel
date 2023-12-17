#!/bin/bash

# 2023 🄯 Pardus Bireysel Contributors
# https://github.com/pardus-bireysel/pardus-bireysel

### Common Functions / Variables for ALL other bash files ###
# NOTE: export keyword used for manuplating shellcheck (otherwise shellcheck suppose variables unusued)

###########################################
############ VARIABLES SECTION ############
###########################################

# NOTE: "General Variables" and "Developer Variables" section moved to src/config.conf file and changeble variables will be created in this file too

### META VARIABLES ###
AUTHOR="pardus-bireysel"
temp_file="$(mktemp -u)"
temp_dir="$(mktemp -d)"
git_provider_name="GitHub"
git_provider_url="https://github.com"
git_repo_name="pardus-bireysel"
git_repo_dest="$git_provider_url/$AUTHOR/$git_repo_name"
git_repo_tag="main"
src_dir=${src_dir:-"$temp_dir/$git_repo_name-$git_repo_tag/src/"}
config_file=${config_file:-"config.conf"}
wait_download=${wait_download:-0}
# user=$([ -n "$SUDO_USER" ] && echo "$SUDO_USER" || echo "$USER")
# home="/home/${user}"
export AUTHOR temp_file temp_dir git_provider_name git_provider_url git_repo_name git_repo_dest git_repo_tag src_dir wait_download

### COLOR CODES ###
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
CYAN='\033[0;36m'
GRAY='\033[4;30m\e[3m'
NC='\033[0m \e[0m' # No Color, No Effect
# BOLD='\033[1;97m'
export RED GREEN ORANGE CYAN GRAY NC

### MISCELLANEOUS ###
PARDUS_LOGO="""
.smNdy+-    \`.:/osyyso+:.\`    -+ydmNs.
/Md- -/ymMdmNNdhso/::/oshdNNmdMmy/. :dM/
mN.     oMdyy- -y          \`-dMo     .Nm
.mN+\`  sMy hN+ -:             yMs  \`+Nm.
 \`yMMddMs.dy \`+\`               sMddMMy\`
   +MMMo  .\`  .                 oMMM+
   \`NM/    \`\`\`\`\`.\`    \`.\`\`\`\`\`    +MN\`
   yM+   \`.-:yhomy    ymohy:-.\`   +My
   yM:          yo    oy          :My
   +Ms         .N\`    \`N.      +h sM+
   \`MN      -   -::::::-   : :o:+\`NM\`
    yM/    sh   -dMMMMd-   ho  +y+My
    .dNhsohMh-//: /mm/ ://-yMyoshNd\`
      \`-ommNMm+:/. oo ./:+mMNmmo:\`
     \`/o+.-somNh- :yy: -hNmos-.+o/\`
    ./\` .s/\`s+sMdd+\`\`+ddMs+s\`/s. \`/.
        : -y.  -hNmddmNy.  .y- :
         -+       \`..\`       +-"""
export PARDUS_LOGO

# END OF VARIABLES !SECTION

###########################################
############ FUNCTIONS SECTION ############
###########################################

### GENERAL FUNCTIONS ###

# feature rich logs with color support
_log() {
  case "$2" in
  panic)
    echo -e "${RED}[ ⚠⚠⚠ ]${NC} $1 ${RED}ABORTING...${NC}"
    exit
    ;;
  err) echo -e "${RED}[ !!! ]${NC} $1" ;;
  warn) echo -e "${ORANGE}[ ⚠ ]${NC} $1" ;;
  ok) echo -e "${GREEN}[ ✔ ]${NC} $1" ;;
  OK) echo -e "${GREEN}[ ✔ ] $1 ${NC}" ;;
  i) echo -e "${CYAN}[ i ]${NC} $1" ;;
  v) if [[ $(_gc "ENABLE_DEV_MODE") -eq 1 ]]; then echo -e "${GRAY}$1${NC}"; fi ;;
  *) echo -e "$1" ;;
  esac

  case "$3" in
  nl) echo " " ;;
  esac
}

_logconf() {
  if [[ "$#" -eq 1 ]]; then
    _log "$1=$(_gc "$1")" v
  else
    _log "$1=$(_gc "$1")" "$2"
  fi
}

# sleep if development mode not activated
_sleep() {
  if [[ $(_gc "ENABLE_DEV_MODE") -eq 0 ]]; then
    sleep "$1"
  else
    if [[ $(_gc "DEV_DISABLE_SLEEP") -eq 1 ]]; then
      sleep "$1"
    else
      _log "sleep skipped" v
    fi
  fi
}

# run with sudo if $2 is not executable
_sudo_run() {
  if [ -x "$2" ]; then
    "$@"
  else
    sudo "$@"
  fi
}

# run any ./script in src directory
_run_script() {
  if [ -f "$src_dir/${1}" ]; then
    _sudo_run bash "$src_dir/${1}"
  else
    _log "File \"${1}\" not exist" err
    _log "Source Dir: $src_dir" v
  fi
}

### USER INTERACTIVITY FUNCTIONS ###

# check input and return boolean value
# $1: user input
# $2: default value (0,1)
_checkinput() {
  case "$1" in
  y | Y | e | E | [yY][eE][sS]) return 1 ;;
  [eE][vV]][eE][tT]) return 1 ;;
  [Yy]*) return 1 ;;
  [Ee]*) return 1 ;;
  n | N | H | h) return 0 ;;
  "" | " " | *) if [ "$2" == 0 ]; then return 0; else return 1; fi ;;
  esac
}

# auto ask question, check answer and return boolean value
# $1: default value (0,1)
# !!! USE AS: "if _checkanswer 1; then" or "if _checkanswer 0; then"
_checkanswer() {
  if [[ "$1" == 1 ]]; then
    read -p "(E/h)? " -r choice
  else
    read -p "(e/H)? " -r choice
  fi

  if _checkinput "$choice" "$1"; then
    return 1
  else
    return 0
  fi

}

# check input and exit if user not confirm progress
_continue_confirmation() {
  read -p "(e/H)? " -r choice
  if _checkinput "$choice" 0; then
    _log "Betik İptal Edildi" i
    exit
  fi
}

### READ / WRITE CONFIG FILE FUNCTIONS ###

# get config
# $1: variable name (e.g. DESKTOP_ENVIRONMENT)
_gc() {
  # when getting repo from remote with remote-run use these temporary files until config.conf file created itself
  if [[ wait_download -eq 1 ]]; then
    case "$1" in
    "ENABLE_DEV_MODE") value=1 ;;
    "DEV_DISABLE_CLEANUP") value=0 ;;
    esac
  else
    value=$(sed -nr "{ :l /^$1[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;} " "$src_dir/$config_file") # REVIEW
  fi
  echo "$value"

  # TODO Değişken mevcut değilse veya UNDEFINED ise hata kodu verilmeli
}

# update config
# $1: variable name (e.g. DESKTOP_ENVIRONMENT)
# $2: value to be updated (e.g. xfce)
_uc() {
  sed -i "s/\($1 *= *\).*/\1$2/" "$src_dir/$config_file" # REVIEW

  # TODO Değişken mevcut değilse yenisi oluşturulmalı (öncesinde verbose veya info çıktısı ile bilgilendirilmeli)
}

### DEVELOPMENT HELPER FUNCTIONS ###

_list_arguments() {
  for ((i = 0; i < "$#"; i++)); do
    echo -n "$i:${!i} - "
  done
  echo -n "$i:${!i}"
}
