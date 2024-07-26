#!/bin/bash

# 2023 - 2024 🄯 Pardus Bireysel Contributors
# https://github.com/pardus-bireysel/pardus-bireysel

## QUICK TEST (for main branch) :
# wget -qO- https://raw.githubusercontent.com/pardus-bireysel/pardus-bireysel/main/install.sh | bash <(cat) </dev/tty

# Error Handling
set -e                       # REVIEW $? will not work!!!
trap _interrupt HUP INT TERM # REVIEW
trap _cleanup EXIT           # REVIEW

source ./common.sh

### FUNCTIONS ###

# prechecks for starting script
_prechecks() {
  if [ "$(awk -F'^ID=' '{print $2}' /etc/os-release | awk 'NF')" != "pardus" ]; then
    _log "Bu betik sadece GNU/Linux Pardus Dağıtımında test edilmiştir, farklı bir sistem için devam etmek betiğin çalışmaması ile sonuçlanabilir!" err
    echo "Devam Etmek İstiyor Musunuz"
    _continue_confirmation
  else
    if [ "$(awk -F'^VERSION_ID=' '{print $2}' /etc/os-release | awk 'NF')" != '"23.1"' ]; then
      _log "Bu betik Pardus Dağıtımının sadece 23.1 sürümü ile test edilmiştir. Kodun belirli kısımları çalışmayabilir" warn
      echo "Devam Etmek İstiyor Musunuz"
      _continue_confirmation

      # TODO GNOME / XFCE masaüstü dağıtımı tespit et, OLD_DESKTOP_ENVIRONMENT olarak ata
      # TODO OLD_DESKTOP_ENVIRONMENT ve NEW_DESKTOP_ENVIRONMENT olarak değişkenleri ayır
    else
      _log "Pardus 23.1 sürümü saptandı" i
      sleep 0.1
      _log "Kurulum için gereksinimler sağlanmakta" ok
    fi
  fi

  sleep 0.2
}

_get_root() {
    export SUDO_PROMPT="Bu script root yetkileriyle çalışır. Lütfen kullanıcı şifrenizi giriniz: "
    sudo true
}

# download other configs from git provider
_download() {
  _log "Yapılandırma dosyaları $git_provider_name üzerinden indiriliyor" i
  if [[ $(_gc "ENABLE_DEV_MODE") -eq 1 ]]; then
    wget -O "$temp_file" "${git_repo_dest}/archive/${git_repo_tag}.tar.gz"
  else
    wget -qO "$temp_file" "${git_repo_dest}/archive/${git_repo_tag}.tar.gz"
  fi
  _log "Yapılandırma dosyalarının son sürümleri $git_provider_name üzerinden indirildi" v

  tar -xzf "$temp_file" -C "$temp_dir"
  _log "Arşiv, $temp_dir dizinine ayıklandı" v

  wait_download=0
}

_preconfigs() {
  # Şimdilik XFCE olduğunu varsayalım # REVIEW
  # TODO Sonrasında OLD_DEKSTOP_ENVIRONMENT ve NEW_DESKTOP_ENVIRONMENT olarak ayrılmış şeklini handle et
  _uc "DESKTOP_ENVIRONMENT" "xfce"

  _log "Masaüstü ortamınızı KDE Plasma ile değiştirmek ister misiniz?" warn
  _log "Bu işlem yaklaşık 1GB veri kullanımına ve 2GB disk kullanımına sebep olur" i
  if _checkanswer 1; then
    _uc "DESKTOP_ENVIRONMENT" "plasma"
  fi
  _logconf "DESKTOP_ENVIRONMENT"
}

# clear cache, delete temporary files
_cleanup() {
  # FIXME running 2 times on exit and sed gives error when could not find config file

  if [[ $(_gc "DEV_DISABLE_CLEANUP") -eq 1 ]]; then
    _log "Cleanup Disabled, you can see files in $temp_dir" v
    exit
  else
    _log "Geçici Dosyalar Temizleniyor ..." i
    rm -rf "$temp_file" "$temp_dir"
    _log "Dosyalar Temizlendi!" ok
    exit
  fi
}

# restart lightdm to kick user to login screen
_restart_lightdm() {
  sudo systemctl restart lightdm
}

# interrupted by user
_interrupt() {
  _log "Betik kullanıcı tarafından erken sonlandırılıyor" err nl
  _cleanup
}

### MAIN ###

if [[ "$1" == "dev" ]]; then
  _log "Geliştirici Modundasınız, ne yaptığınızı bilmiyorsanız bu betiği sonlandırınız!!!" warn
  source development.sh
  if [[ "$2" == "remote-run" ]]; then
    _DEV_RUN "remote" "$3"
  elif [[ "$2" == "local-run" ]]; then
    _DEV_RUN "local"
  elif [[ "$2" == "" ]]; then
    _DEV_RUN "tmp"
    __TMP_DEV "$@"
    exit
  fi
fi

_sleep 1
echo -e "$ORANGE $PARDUS_LOGO $NC \nPARDUS BİREYSEL - KURULUM BETİĞİ"
_sleep 1

if [[ $(_gc "DEV_DISABLE_PRECHECKS") -eq 0 ]]; then
  _prechecks
fi
if [[ $(_gc "DEV_DISABLE_DOWNLOAD") -eq 0 ]]; then
  _download
  _uc "ENABLE_DEV_MODE" 1
fi
_preconfigs
_get_root


if [[ $(_gc "DESKTOP_ENVIRONMENT") == "plasma" ]]; then
  echo -e "$INSTALLATION_NOTES $NC\n\n30 saniye bekleniyor..."
  _sleep 30

  _run_script "kde_install.sh"
  _run_script "remove_apps.sh"
  _run_script "install_apps.sh"
  _run_script "kde_configurations.sh"
  _restart_lightdm
else
  _log "Betik Sonlandırıldı - Herhangi bir değişiklik yapılmadı" warn
fi

