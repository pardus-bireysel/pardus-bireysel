# pardus-bireysel
Pardus XFCE sürümünü Pardus KDE Bireysel sürümüne dönüştüren kod betiği

## Kurulum
### Ana Kol için kurulum
```bash
wget -qO- https://raw.githubusercontent.com/pardus-bireysel/pardus-bireysel/main/install.sh | bash <(cat) </dev/tty
```
### remove-unnecessary-apps kolu için GELİŞTİRİCİ Kurulumu
```bash
wget -qO- https://raw.githubusercontent.com/pardus-bireysel/pardus-bireysel/remove-unnecessary-apps/install.sh | bash <(cat) </dev/tty dev branch remove-unnecessary-apps
```

---

## Yol Haritası:
1. Gereksiz Uygulamaları Kaldır [WIP: #1](https://github.com/pardus-bireysel/pardus-bireysel/pull/1)
2. XFCE masaüstü ortamını KDE Plasma'ya dönüştür
3. KDE **uygulamalarının** uygulamalarının yüklenmesi ve varsayılan ayarların belirlenmesi 
4. KDE **servislerinin** düzenlenmesi ve gerekli önayarların yapılması
5. Plasma ayarlarını kullanıcılar için en hazır şekilde ayarlamak
6. GNOME masaüstünden dönüştürme desteği
7. KDE ilk defa açıldıktan sonra belirli bir script çalıştırmak (cli/tui, pre/post-conf.sh) - (pardus-kde-greeter, hoşgeldin uygulaması)
8. Pardus Bireysel betiğini arayüz olarak çalıştırabilecek bir GTK uygulaması yazmak (bu scriptlerin kullanım ömrünün dolması)
9. Kullanıcı dostu yeni Pardus araçları için çalışmaya başlanması (harici depolarda)