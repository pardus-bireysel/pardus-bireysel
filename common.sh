#!/bin/bash

# 2023 🄯 Pardus Bireysel Contributors
# https://github.com/pardus-bireysel/pardus-bireysel

### Common Functions / Variables for ALL other bash files ###
# NOTE: export keyword used for manuplating shellcheck (otherwise shellcheck suppose variables unusued)

###########################################
############ VARIABLES SECTION ############
###########################################

### META VARIABLES ###
AUTHOR="pardus-bireysel"
temp_file="$(mktemp -u)"
temp_dir="$(mktemp -d)"
git_provider_name="GitHub"
git_provider_url="https://github.com"
git_repo_name="pardus-bireysel"
git_repo_dest="$git_provider_url/$AUTHOR/$git_repo_name"
git_repo_tag="main"
src_dir="$temp_dir/$git_repo_name-$git_repo_tag/src/"
# user=$([ -n "$SUDO_USER" ] && echo "$SUDO_USER" || echo "$USER")
# home="/home/${user}"
export AUTHOR temp_file temp_dir git_provider_name git_provider_url git_repo_name git_repo_dest git_repo_tag src_dir

### GENERAL VARIABLES ###
DESKTOP_ENVIRONMENT="plasma" # supported: plasma, xfce, gnome
export DESKTOP_ENVIRONMENT

### DEVELOPER VARIABLES ###
_PARDUS_DEV_MODE=0
_ENABLE_SLEEP=0
_DISABLE_DOWNLOAD=0
_DISABLE_PRECHECKS=0
_DISABLE_CLEANUP=0
export _PARDUS_DEV_MODE _ENABLE_SLEEP _DISABLE_DOWNLOAD _DISABLE_PRECHECKS _DISABLE_CLEANUP

### COLOR CODES ###
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m \e[3m'
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
  # REVIEW aynı tür logları birden fazla kelime ile kabul etmek mantıklı mı? Gerek var mı?
  case "$2" in
  fatal | panic)
    echo -e "${RED}[ ⚠⚠⚠ ]${NC} $1 ${RED}ABORTING...${NC}"
    exit
    ;;
  error | err) echo -e "${RED}[ !!! ]${NC} $1" ;;
  warning | warn) echo -e "${ORANGE}[ ⚠ ]${NC} $1" ;;
  ok | okey | done | success) echo -e "${GREEN}[ ✔ ]${NC} $1" ;;
  DONE | OK) echo -e "${GREEN}[ ✔ ] $1 ${NC}" ;;
  info | inf | status) echo -e "${CYAN}[ i ]${NC} $1" ;;
  verbose | v | verb) if [[ _PARDUS_DEV_MODE -eq 1 ]]; then echo -e "${GRAY}$1${NC}"; fi ;;
  *) echo -e "$1" ;;
  esac

  case "$3" in
  newline | nl | new | newl) echo " " ;;
  esac
}

# sleep if development mode not activated
_sleep() {
  if [[ "$_PARDUS_DEV_MODE" -eq 0 ]]; then
    sleep "$1"
  else
    if [[ "$_ENABLE_SLEEP" -eq 1 ]]; then
      sleep "$1"
    else
      _log "sleep skipped" verbose
    fi
  fi
}

#run with sudo if $2 is not executable
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
    _log "Source Dir: $src_dir" verbose
  fi
}

### USER INTERACTIVITY FUNCTIONS ###

# check input and return boolean value
_checkinput() {
  case "$1" in
  y | Y | e | E | [yY][eE][sS]) return 1 ;;
  [eE][vV]][eE][tT]) return 1 ;;
  [Yy]*) return 1 ;;
  [Ee]*) return 1 ;;
  "" | " ") return 1 ;;
  n | N | H | h | *) return 0 ;;
  esac
  # TODO bazı durumlarda varsayılan enter işlevinin 0 dönmesi istenebilir! Burada 0 mı dönüyor 1 mi???
  # Default halini degisken olarak ekle
}

# auto ask question, check answer and return boolean value
_checkanswer() {
  read -p "(E/H)? " -r choice
  if _checkinput "$choice" -eq 1; then
    return 1
  else
    return 0
  fi

}

# check input and exit if user not confirm progress
_continue_confirmation() {
  read -p "(E/H)? " -r choice
  if _checkinput "$choice" -eq 0; then
    _log "Betik İptal Edildi" info
    exit
  fi
}

### DEVELOPMENT HELPER FUNCTIONS ###

_list_arguments() {
  for ((i = 0; i < "$#"; i++)); do
    echo -n "$i:${!i} - "
  done
  echo -n "$i:${!i}"
}
