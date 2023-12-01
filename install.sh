#!/bin/bash

# 2023 🄯 Pardus Bireysel Contributors
# https://github.com/pardus-bireysel/pardus-bireysel

## QUICK TEST (for main branch) :
# wget -qO- https://raw.githubusercontent.com/pardus-bireysel/pardus-bireysel/main/install.sh | bash <(cat) </dev/tty

# Error Handling
set -e
trap _interrupt HUP INT TERM # REVIEW
trap _cleanup EXIT           # REVIEW

source ./common.sh

### FUNCTIONS ###

# prechecks for starting script
_prechecks() {
  if [ "$(awk -F'^ID=' '{print $2}' /etc/os-release | awk 'NF')" != "pardus" ]; then
    _log "Bu betik sadece GNU/Linux Pardus Dağıtımında (23.0 sürümü) test edilmiştir, farklı bir sistem için devam etmek betiğin çalışmaması ile sonuçlanabilir!" err
    echo "Devam Etmek İstiyor Musunuz"
    _continue_confirmation
  else
    if [ "$(awk -F'^VERSION_ID=' '{print $2}' /etc/os-release | awk 'NF')" != '"23.0"' ]; then
      _log "Bu betik Pardus Dağıtımının sadece 23.0 sürümü ile test edilmiştir. Kodun belirli kısımları çalışmayabilir" warn
      echo "Devam Etmek İstiyor Musunuz"
      _continue_confirmation
    else
      # TODO GNOME / XFCE masaüstü dağıtımı tespit etme
      _log "Pardus 23.0 sürümü saptandı" info
      sleep 0.1
      _log "Kurulum için gereksinimler sağlanmakta" ok
    fi
  fi

  sleep 0.2

  # REVIEW Meb internetini kullanmak için setifika kurmak lazım ama son kullanıcının şimdilik ihtiyacı olmaz. Ileride opsiyonel olarak ayarlanabilir
  # _log "Eğer Fatih/MEB internetine ethernet ile bağlı iseniz Sertifika kurmanız gerekebilir. Sertifikayı kurmak istiyor musunuz?" warn
  # if _checkanswer -eq 1; then
  #   _log "MEB sertifikası indiriliyor..." verbose
  #   timeout 10 wget -qO "$temp_file" "http://sertifika.meb.gov.tr/MEB_SERTIFIKASI.cer" || (_log "Sertifikayı yüklemeye çalışırken bir hata oluştu" fatal)

  #   _log ".cer uzantılı sertifika dosyası .crt uzantılı sertifika dosyasına dönüştürülüyor..." verbose
  #   openssl x509 -inform DER -in "$temp_file" -out "$temp_file"

  #   _log "Sertifika /usr/local/share/ca-certificates/ dizinine taşınıyor" verbose
  #   sudo mv "$temp_file" "/usr/local/share/ca-certificates/MEB_SERTIFIKASI.crt"

  #   _log "Sertifika dosyasına gerekli izinler veriliyor" verbose
  #   sudo chmod 644 /usr/local/share/ca-certificates/MEB_SERTIFIKASI.crt

  #   _log "Sertifikalar yenileniyor..." verbose
  #   sudo update-ca-certificates

  #   _log "MEB Sertifikası başarılı bir şekilde kuruldu, Tarayıcılara manuel olarak eklemeniz gerekebilir" "done"
  # fi
}

# download other configs from git provider
_download() {
  wget -O "$temp_file" "${git_repo_dest}/archive/${git_repo_tag}.tar.gz"
  _log "Yapılandırma dosyalarının son sürümleri $git_provider_name üzerinden indirildi" ok

  tar -xzf "$temp_file" -C "$temp_dir"
  _log "Arşiv, $temp_dir dizinine ayıklandı" verbose
}

# clear cache, delete temporary files
_cleanup() {
  if [[ _DISABLE_CLEANUP -eq 1 ]]; then
    _log "Cleanup Disabled, you can see files in $temp_dir" verbose
    exit
  else
    _log "Geçici Dosyalar Temizleniyor ..." info
    rm -rf "$temp_file" "$temp_dir"
    _log "Dosyalar Temizlendi!" "done"
    exit
  fi
}

# interrupted by user
_interrupt() {
  _log "Betik kullanıcı tarafından erken sonlandırılıyor" err newline
  _cleanup
}

### MAIN ###
#TODO Advanced Argument/Flag Handling, see: https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash , https://www.redhat.com/sysadmin/arguments-options-bash-scripts and https://www.assertnotmagic.com/2019/03/08/bash-advanced-arguments/#TODO Help text (tr)
#TODO Man pages (tr-en)
echo "$@"
if [[ "$1" == "dev" ]]; then
  _log "Geliştirici Modundasınız, ne yaptığınızı bilmiyorsanız bu betiği sonlandırınız!!!" warn
  source development.sh # ANCHOR[id=source_development]
  _PARDUS_DEV_MODE=1
  # _ENABLE_SLEEP=1 # Uncomment if you want to wait in dev mode
  # _DISABLE_CLEANUP=1
  _sleep 5

  if [[ "$2" == "remote-run" ]]; then
    _DEV_RUN "remote" "$3"
  elif [[ "$2" == "local-run" ]]; then
    _DEV_RUN "local"
  else
    __TMP_DEV "$@"
    exit
  fi
fi

_sleep 6
echo -e "$ORANGE $PARDUS_LOGO $NC \nPARDUS BİREYSEL - KURULUM BETİĞİ"
_sleep 1

if [[ "_DISABLE_PRECHECKS" -eq 0 ]]; then
  _prechecks
fi
if [[ "_DISABLE_DOWNLOAD" -eq 0 ]]; then
  _download
fi

_log "Masaüstü ortamınızı KDE Plasma ile değiştirmek ister misiniz?" warn
if _checkanswer -eq 0; then
  DESKTOP_ENVIRONMENT="xfce"
fi
echo "$DESKTOP_ENVIRONMENT"
# TODO GNOME'u da algıla ve buraya ekle

_run_script "remove_apps.sh"
# _run_script "kde_install.sh"
# _run_script "kde_configurations.sh"
