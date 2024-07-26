# pardus-bireysel
Bu betik hâlihazırda kurulu olan Pardus 23 XFCE veya GNOME sürümünü KDE sürümüne dönüştürür. XFCE ve GNOME masaüstü ortamları ile ilgili paketleri kaldırır ve KDE paketlerini yükler. Aynı zamanda sık kullanılmayan bazı uygulamaları kaldırarak daha ferah ve hızlı bir kullanım sağlar 

### Tek Satırda Kurulum
```bash
wget -q -O install.sh https://raw.githubusercontent.com/pardus-bireysel/pardus-bireysel/main/install.sh && wget -q -O common.sh https://raw.githubusercontent.com/pardus-bireysel/pardus-bireysel/main/common.sh && chmod +x ./install.sh && ./install.sh
```
### Git İle
```bash
git clone https://github.com/pardus-bireysel/pardus-bireysel/
cd pardus-bireysel
./install.sh
```