#!/bin/bash

# 2023 🄯 Pardus Bireysel Contributors
# https://github.com/pardus-bireysel/pardus-bireysel

### Development functions to use in other files while testing ###

source ./common.sh
# REVIEW sourcing common.sh here again actually overrides common.sh values from install.sh
### WORKAROUND -> source this file (develpoment.sh) before variable assign line. See LINK install.sh#source_development

# Temporary Development/Test Section
__TMP_DEV() {
  _log "--- Geçici Geliştirici Fonksiyonu Başlatıldı ---\n" info
  if [[ "$#" -eq 0 ]]; then
    _log "there is no passed variables" verbose
  else
    _log "passed variables: $(_list_arguments "$@")" verbose newline
  fi
  #########################################
  ########## TEMPORARY TEST AREA ##########

  echo "$_PARDUS_DEV_MODE"

  #########################################
  #########################################
  _log "--- Geçici Geliştirici Fonksiyonu Sonlandırıldı ---\n\n" info
}

# run code as developer in remote or local mode
_DEV_RUN() {
  echo "$_PARDUS_DEV_MODE"
  if [[ "$1" == "remote" ]]; then
    git_repo_tag="$2"
    src_dir="$temp_dir/$git_repo_name-$git_repo_tag/src/"
    _log "Branch değiştirildi: ${git_repo_tag}" info
  elif [[ "$1" == "local" ]]; then
    _DISABLE_DOWNLOAD=1
    _DISABLE_PRECHECKS=1 # optional
    cp -r ./ "$temp_dir/LOCAL/"
    src_dir="$temp_dir/LOCAL/src/"
  fi
}