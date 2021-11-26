import "package:http/http.dart" as http;
import 'package:yolcusen/models/arac.dart';

class AracApi {
  static Future getAracFiltre(String sahip) {
    return http.get(
        Uri.parse("http://yolcusen.fuatsengul.net/arac.php?islem=tekArac&sahip=" + sahip));
  }
  static Future aracSil(String aracId) {
    return http.get(
        Uri.parse("http://yolcusen.fuatsengul.net/arac.php?islem=aracSil&aracId=" + aracId));
  }
  static Future addArac(Arac arac) {
    var veri = {
      "islem": "kayitEkle",
      "aracPlaka": arac.aracPlaka,
      "sahip": arac.sahip.toString(),
      "aracAd": arac.aracAd
    };
    return http.post(Uri.parse("http://yolcusen.fuatsengul.net/arac.php"),
        body: veri);
  }
}
