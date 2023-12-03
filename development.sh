#!/bin/bash

# 2023 🄯 Pardus Bireysel Contributors
# https://github.com/pardus-bireysel/pardus-bireysel

### Development functions to use in other files while testing ###

source ./common.sh

# Temporary Development/Test Section
__TMP_DEV() {
  _log "--- Geçici Geliştirici Fonksiyonu Başlatıldı ---" i nl
  if [[ "$#" -eq 1 ]]; then
    _log "there is no passed variables" v
  else
    _log "passed variables: $(_list_arguments "$@")" v nl
  fi
  #########################################
  ########## TEMPORARY TEST AREA ##########

  #########################################
  #########################################
  _log "--- Geçici Geliştirici Fonksiyonu Sonlandırıldı ---\n" i nl
}

# run code as developer in remote or local mode
_DEV_RUN() {
  if [[ "$1" == "remote" ]]; then
    git_repo_tag="$2"
    src_dir="$temp_dir/$git_repo_name-$git_repo_tag/src/"
    _log "Branch değiştirildi: ${git_repo_tag}" i
    wait_download=1
  else
    if [[ "$1" == "local" ]]; then
      cp -r ./ "$temp_dir/LOCAL/"
      src_dir="$temp_dir/LOCAL/src/"
      _uc "DEV_DISABLE_DOWNLOAD" 1
      _uc "DEV_DISABLE_PRECHECKS" 1 # optional
    elif [[ "$1" == "tmp" ]]; then
      cp -r ./ "$temp_dir/LOCAL/"
      src_dir="$temp_dir/LOCAL/src/"
    fi
    _uc "ENABLE_DEV_MODE" 1
    # _uc "DEV_ENABLE_SLEEP" 1 # Uncomment if you want to wait in dev mode
    _uc "DEV_DISABLE_CLEANUP" 1
  fi
}
