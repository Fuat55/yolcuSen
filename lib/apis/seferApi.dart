import "package:http/http.dart" as http;
import 'package:yolcusen/models/sefer.dart';

class SeferApi {
  static Future getSeferTum() {
    return http.get(
        Uri.parse("http://yolcusen.fuatsengul.net/sefer.php?islem=tumListe"));
  }
  static Future getSeferTarih(String tarih) {
    return http.get(
        Uri.parse("http://yolcusen.fuatsengul.net/sefer.php?islem=tumListeTarih&tarih=" + tarih));
  }
  static Future getSeferFiltre(String seferSahip) {
    return http.get(
        Uri.parse("http://yolcusen.fuatsengul.net/sefer.php?islem=tekSefer&seferSahip=" + seferSahip));
  }
  static Future seferTekBilgi(String seferId) {
    return http.get(
        Uri.parse("http://yolcusen.fuatsengul.net/sefer.php?islem=seferTekBilgi&seferId=" + seferId));
  }
  static Future seferSil(String seferId) {
    return http.get(
        Uri.parse("http://yolcusen.fuatsengul.net/sefer.php?islem=seferSil&seferId=" + seferId));
  }
  static Future addSefer(Sefer sefer) async{
    var veri = {
      "islem": "kayitEkle",
      "aracId": sefer.aracId.toString(),
      "seferSahip": sefer.seferSahip.toString(),
      "saat": sefer.saat,
      "tarih": sefer.tarih,
      "yer": sefer.yer,
      "yolcuSayisi":sefer.yolcuSayisi.toString()
    };
    return http.post(Uri.parse("http://yolcusen.fuatsengul.net/sefer.php"),
        body: veri);
  }
}
