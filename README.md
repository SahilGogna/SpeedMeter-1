# SpeedMeter

![](https://img.shields.io/teamcity/codebetter/bt428.svg)
![](https://img.shields.io/badge/swift-3.0-red.svg)
![](https://img.shields.io/badge/xcode-8.3-blue.svg)
![](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![](https://img.shields.io/badge/license-Apache%202.0-yellow.svg)

### Uygulama içinden görüntüler
![ScreenShot](https://raw.github.com/mustafagunes/SpeedMeter/master/README%20Docs/speedmeter.gif)

İÇERİK
------
Aşağıda uygulamada için kullanılan araçlar ve kütüphanelerin listesi yer alıyor.

1. POD - Üçüncü parti kütüphaneleri yüklediğim araç
    - [lottie-ios](https://github.com/airbnb/lottie-ios) - JSON uzantılı dosyalar ile çok düşük boyutlarda alan kaplayarak mükemmel animasyonlar sağlıyor.
    - [LTMorphingLabel](https://github.com/lexrus/LTMorphingLabel) - Bir çok farklı animasyon ile geçişler sunan kütüphane.
    - [CNPPopupController](https://github.com/carsonperrotti/CNPPopupController) - Bildirimler için yazılmış basit popup kütüphanesi.
    - [RevealingSplashView](https://github.com/PiXeL16/RevealingSplashView) - Uygulama başlangıcında LaunchScreen'i kullanarak efektli uygulama başlangıcı sağlıyor.
    
2. GIT - Versiyon Kontrol
    - ```git add -A``` - Bulunduğunuz dosyadaki bütün parçaları alır.
    - ```git commit -m "<description>"``` - Yaptığınız değişikliklerden sonra versiyonla alakalı açıklama kısmı.
    - ```git push -u origin master``` - Yukarıdakileri sırası ile yaptıysanız, bu komutla Github, Gitlab ve BitBucket gibi depolara projenizi gönderebilirsiniz

**Not:** Yukarıdaki komutlar git içerisindeki bazı komutlardır. Komutların tamamı için : [GIT Docs](https://git-scm.com/docs)
    
Projeyi İndirme & Kurma
-----------------------

* Elle Kurulum
    - [Bu linke tıkyarak projeyi .zip olarak indirin](https://github.com/mustafagunes/SpeedMeter/archive/master.zip)
    - İndirme işlemi bittikten sonra, dosyaları çıkartın.
    - Ardından ExportContact(VCard).xcworkspace çift tıklayarak projeyi çalıştırın.

* Terminal ile Kurulum
    - Aşağıdaki komutları sırasıyla terminale yazın ve çalıştırın:
        * ```git clone https://github.com/mustafagunes/SpeedMeter.git```
        * ```cd SpeedMeter```
    - Son olarak aşağıdaki komutu yazın ve çalıştırın:
        * ```open SpeedMeter.xcworkspace```
