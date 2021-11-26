import "package:http/http.dart" as http;
import 'package:yolcusen/models/kullanici.dart';

class KullaniciApi {
  static Future getTumKullanici() {
    return http
        .get(Uri.parse("http://yolcusen.fuatsengul.net/kullanici.php?islem=tumListe"));
  }

  static Future getKullanici(String kullaniciAdi, String sifre){
    var veri = {
      "islem": "tekKullanici",
      "kullaniciAdi": kullaniciAdi,
      "sifre": sifre
    };
    return http.post(Uri.parse("http://yolcusen.fuatsengul.net/kullanici.php"),
        body: veri);
  }

  static Future getKontrol(String kullaniciAdi) {
    return http.get(
        Uri.parse("http://yolcusen.fuatsengul.net/kullanici.php?islem=kullaniciKontrol&kullanici=" +
            kullaniciAdi));
  }

  static Future addKullanici(Kullanici kullanici) {
    var veri = {
      "islem": "kayitEkle",
      "adSoyad": kullanici.adSoyad,
      "telefon": kullanici.telefon,
      "kullaniciAdi": kullanici.kullaniciAdi,
      "sifre": kullanici.sifre
    };
    return  http.post(Uri.parse("http://yolcusen.fuatsengul.net/kullanici.php"),
        body: veri);
  }
}
