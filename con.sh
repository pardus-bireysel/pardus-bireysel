#!/bin/bash

rm -rf ~/con/*
rm -rf ~/con/.config

mkdir -p ~/con/.config/libreoffice/4/user
mkdir -p ~/con/.local/share/


cp -r ~/.config/gtk-3.0 ~/con/.config
cp -r ~/.config/gtk-4.0 ~/con/.config
cp -r ~/.config/kcminputrc ~/con/.config
cp -r ~/.config/kconf_updaterc ~/con/.config
cp -r ~/.config/kdedefaults ~/con/.config
cp -r ~/.config/kdeglobals ~/con/.config
cp -r ~/.config/khotkeysrc ~/con/.config
cp -r ~/.config/kglobalshortcutsrc ~/con/.config
cp -r ~/.config/konsolerc ~/con/.config
cp -r ~/.config/ksplashrc ~/con/.config
cp -r ~/.config/kwinrc ~/con/.config
cp -r ~/.config/mimeapps.list ~/con/.config
cp -r ~/.config/plasmanotifyrc ~/con/.config
cp -r ~/.config/plasma-org.kde.plasma.desktop-appletsrc ~/con/.config
cp -r ~/.config/plasmarc ~/con/.config
cp -r ~/.config/plasmashellrc ~/con/.config
cp -r ~/.config/touchegg ~/con/.config
cp -r ~/.config/xsettingsd ~/con/.config

cp -r ~/.config/autostart/ ~/con/.config


cp -r registrymodifications.xcu ~/con/.config/libreoffice/4/user


cp -r ~/.icons ~/con

cp -r ~/.local/share/applications  ~/con/.local/share/
cp -r ~/.local/share/color-schemes  ~/con/.local/share/
cp -r ~/.local/share/icons  ~/con/.local/share/
cp -r ~/.local/share/konsole  ~/con/.local/share/
cp -r ~/.local/share/plasma  ~/con/.local/share/
cp -r ~/.local/share/themes  ~/con/.local/share/

#rm -rf ~/gecici/kaynak/tmp/con
#cp -r ~/con ~/gecici/kaynak/tmp/
