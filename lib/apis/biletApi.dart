import "package:http/http.dart" as http;
import 'package:yolcusen/models/bilet.dart';

class BiletApi {
  static Future getBiletlerim(String kullanici) {
    return http.get(
        Uri.parse("http://yolcusen.fuatsengul.net/bilet.php?islem=biletlerim&kullanici=" +
            kullanici));
  }
  static Future getBiletFiltre(String sefer) {
    return http.get(
        Uri.parse("http://yolcusen.fuatsengul.net/bilet.php?islem=tekBilet&seferId=" +
            sefer));
  }
  static Future biletGuncelle(int BiletNo, String yer, int yolcu) {
    var veri = {
      "islem": "biletGuncelle",
      "kullaniciId": yolcu.toString(),
      "binecekYer": yer,
      "biletId": BiletNo.toString()
    };

    return http.post(Uri.parse("http://yolcusen.fuatsengul.net/bilet.php"), body: veri);
  }
  static Future biletSil(int BiletNo, String yer, int yolcu) {
    var veri = {
      "islem": "biletSil",
      "kullaniciId": yolcu.toString(),
      "binecekYer": yer,
      "biletId": BiletNo.toString()
    };

    return http.post(Uri.parse("http://yolcusen.fuatsengul.net/bilet.php"), body: veri);
  }
  static Future addBilet(Bilet bilet) {
    var veri = {
      "islem": "kayitEkle",
      "kullaniciId": bilet.kullaniciId.toString(),
      "seferId": bilet.seferId.toString(),
      "koltukNo": bilet.koltukNo.toString(),
      "binecekYer": bilet.binecekYer,
      "doluMu": bilet.doluMu.toString()
    };
    return http.post(Uri.parse("http://yolcusen.fuatsengul.net/bilet.php"), body: veri);
  }
}
