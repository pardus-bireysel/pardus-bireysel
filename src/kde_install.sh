#!/bin/bash

# 2023 - 2024 🄯 Pardus Bireysel Contributors
# https://github.com/pardus-bireysel/pardus-bireysel

# Plasma masaüstü ortamının yüklenmesi ve ilgili KDE uygulamalarının yüklenmesi

# REVIEW Komutun Kde plasma ortamı uygulamalarını indirip indirmediği belirlenmesi gerek.
sudo apt-get -y install kde-plasma-desktop --no-install-recommends
# REVIEW kde-plasma-desktop vs kde-standard vs kde-full ???