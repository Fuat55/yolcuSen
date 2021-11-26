import "package:http/http.dart" as http;
import 'package:yolcusen/models/hata.dart';

class HataApi {
  static Future addHata(Hata hata) {
    var veri = {
      "islem": "kayitEkle",
      "hataEkleyen": hata.hataEkleyen.toString(),
      "baslik": hata.baslik,
      "aciklama": hata.aciklama
    };
    return http.post(Uri.parse("http://yolcusen.fuatsengul.net/hata.php"), body: veri);
  }
}
