#!/bin/bash


### gerekli paketler
apt install debootstrap xorriso squashfs-tools mtools grub-pc-bin grub-efi-amd64 -y

### Chroot oluşturmak için
mkdir kaynak
chown root kaynak

### Testing için
debootstrap --arch=amd64 yirmiuc-deb kaynak http://depo.pardus.org.tr/pardus

### bind bağı için
for i in dev dev/pts proc sys; do mount -o bind /$i kaynak/$i; done

sleep 5

echo 'depo ekleniyor...'

### Depo eklemek için
echo 'deb http://depo.pardus.org.tr/pardus yirmiuc-deb main contrib non-free non-free-firmware' > kaynak/etc/apt/sources.list
echo 'deb-src http://depo.pardus.org.tr/pardus yirmiuc-deb main contrib non-free non-free-firmware' >> kaynak/etc/apt/sources.list
echo 'deb http://depo.pardus.org.tr/guvenlik yirmiuc-deb main contrib non-free non-free-firmware' >> kaynak/etc/apt/sources.list
echo 'deb-src http://depo.pardus.org.tr/guvenlik yirmiuc-deb main contrib non-free non-free-firmware' >> kaynak/etc/apt/sources.list
echo 'deb http://depo.pardus.org.tr/pardus yirmiuc main contrib non-free non-free-firmware' >> kaynak/etc/apt/sources.list
echo 'deb-src http://depo.pardus.org.tr/pardus yirmiuc main contrib non-free non-free-firmware' >> kaynak/etc/apt/sources.list


chroot kaynak apt install wget -y

mkdir /tmp/deb
chroot kaynak wget -c https://depo.pardus.org.tr/pardus/pool/main/p/pardus-archive-keyring/pardus-archive-keyring_2021.1_all.deb -P /tmp/deb

chroot kaynak dpkg -i /tmp/debpardus-archive-keyring_2021.1_all.deb

chroot kaynak apt install --fix-missing -y
chroot kaynak apt install --fix-broken -y

chroot kaynak apt update -y

chroot kaynak apt upgrade -y

chroot kaynak apt install linux-image-amd64 -y

### grub paketleri için
chroot kaynak apt install grub-pc-bin grub-efi-ia32-bin grub-efi -y

### live paketleri için
chroot kaynak apt install live-config live-boot -y 

chroot kaynak apt install bluez-firmware firmware-amd-graphics firmware-atheros firmware-b43-installer firmware-b43legacy-installer firmware-bnx2 firmware-bnx2x firmware-brcm80211 firmware-cavium firmware-intel-sound  firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas firmware-linux firmware-linux-free firmware-linux-nonfree firmware-misc-nonfree firmware-myricom firmware-netxen firmware-qlogic  firmware-realtek firmware-samsung firmware-siano firmware-ti-connectivity firmware-zd1211 -y


chroot kaynak apt install kde-standard -y # tam paket için kde-full

chroot kaynak apt purge juk kmail* plasma-discover konqueror kwrite kde-spectacle zutty

### Yazıcı tarayıcı ve bluetooth paketlerini kuralım (isteğe bağlı)
chroot kaynak apt install printer-driver-all system-config-printer simple-scan blueman -y

chroot kaynak apt install pardus-about pardus-ayyildiz-grub-theme pardus-backgrounds pardus-font-manager pardus-image-writer pardus-installer pardus-java-installer pardus-locales pardus-menus pardus-mycomputer pardus-night-light pardus-package-installer pardus-software pardus-update pardus-usb-formatter pardus-wallpaper-23-0 git system-monitoring-center -y

chroot kaynak apt install bash-completion firefox-esr firefox-esr-l10n-tr libreoffice libreoffice-kf5 libreoffice-l10n-tr flameshot elisa -y


#gesture, libre office theme, emulatör
chroot kaynak wget -c https://github.com/JoseExposito/touchegg/releases/download/2.0.17/touchegg_2.0.17_amd64.deb -P /tmp/deb
chroot kaynak wget -c http://archive.ubuntu.com/ubuntu/pool/main/libr/libreoffice/libreoffice-style-yaru_7.5.2-0ubuntu1_all.deb -P /tmp/deb
chroot kaynak wget -c https://github.com/halak0013/pardus_android_emulator/releases/download/Pardus_Android_Emulator_v1.3/pardus-android-emulator_1.3_all.deb -P /tmp/deb

chroot kaynak dpkg -i /tmp/deb/touchegg_2.0.17_amd64.deb
chroot kaynak dpkg -i /tmp/deb/libreoffice-style-yaru_7.5.2-0ubuntu1_all.deb
chroot kaynak dpkg -i /tmp/deb/pardus-android-emulator_1.3_all.deb

chroot kaynak apt install --fix-missing -y
chroot kaynak apt install --fix-broken -y

cp -r con/.* kaynak/etc/skel/

wget -O /etc/skel/Applications/NormCap.AppImage https://github.com/dynobo/normcap/releases/download/v0.4.4/NormCap-0.4.4-x86_64.AppImage

chroot kaynak apt upgrade -y

umount -lf -R kaynak/* 2>/dev/null

### temizlik işlemleri
chroot kaynak apt autoremove -y
chroot kaynak apt clean -y
rm -rf kaynak/tmp/.*
rm -rf kaynak/tmp/*
rm -f kaynak/root/.bash_history
rm -rf kaynak/var/lib/apt/lists/*
find kaynak/var/log/ -type f | xargs rm -f


### isowork filesystem.squashfs oluşturmak için
mkdir isowork
mksquashfs kaynak filesystem.squashfs -comp gzip -wildcards
mkdir -p isowork/live
mv filesystem.squashfs isowork/live/filesystem.squashfs

cp -pf kaynak/boot/initrd.img* isowork/live/initrd.img
cp -pf kaynak/boot/vmlinuz* isowork/live/vmlinuz

### iso oluşturma
mkdir -p isowork/boot
cp -r grub/ isowork/boot/


grub-mkrescue isowork -o P23-KDE-amd64.iso


# sudo apt remove knavalbattle artikulate juk timidity blinken cantor kalgebra kalzium kanagram kbruch marble kgeography khangman kig kiten klettres kmplot ktouch kturtle kwordquiz minuet parley rocs step cervisia kapptemplate kcachegrind kimagemapeditor kuiviewer lokalize umbrello imagemagick kruler kcolorchooser kontrast akregator kget konqueror kmail krdc krfb kmouth kcharselect kteatime kgpg kleopatra okteta ktimer kontact bomber bovo gnugo granatier ksnakeduel kajongg kapman katomic kblackbox kblocks kbounce kbreakout kdiamond kfourinline kgoldrunner kigo killbots kiriki kjumpingcube klickety kmahjongg kmines knetwalk knights kolf kollision kpat kreversi konquest ksirk ksquares ksudoku kubrick lskat palapeli ktuberling kshisen picmi klines kspaceduel zutty 
# chroot kaynak apt remove knavalbattle artikulate juk timidity blinken cantor kalgebra kalzium kanagram kbruch marble kgeography khangman kig kiten klettres kmplot ktouch kturtle kwordquiz minuet parley rocs step cervisia kapptemplate kcachegrind kimagemapeditor kuiviewer lokalize umbrello imagemagick kruler kcolorchooser kontrast akregator kget konqueror kmail krdc krfb kmouth kcharselect kteatime kgpg kleopatra okteta ktimer kontact bomber bovo gnugo granatier ksnakeduel kajongg kapman katomic kblackbox kblocks kbounce kbreakout kdiamond kfourinline kgoldrunner kigo killbots kiriki kjumpingcube klickety kmahjongg kmines knetwalk knights kolf kollision kpat kreversi konquest ksirk ksquares ksudoku kubrick lskat palapeli ktuberling kshisen picmi klines kspaceduel zutty 
# chroot kaynak apt autoremove
