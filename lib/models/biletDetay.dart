class BiletDetay {
  int biletId = 0;
  String tarih = "02/02/2021";
  String saat = "07.10";
  String adSoyad = "ad";
  String aracPlaka = "plaka";
  String telefon = "telefon";
  String aracAd = "";
  int koltukNo = 0;

  BiletDetay(this.biletId, this.tarih, this.saat, this.adSoyad, this.aracPlaka,
      this.aracAd,this.telefon, this.koltukNo);

  BiletDetay.fromJson(Map<String, dynamic> json) {
    biletId = int.parse(json["biletId"]);
    tarih = json["tarih"];
    saat = json["saat"];
    adSoyad = json["adSoyad"];
    aracPlaka = json["aracPlaka"];
    aracAd = json["aracAd"];
    telefon = json["telefon"];
    koltukNo = int.parse(json["koltukNo"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "biletId": biletId,
      "tarih": tarih,
      "saat": saat,
      "adSoyad": adSoyad,
      "aracPlaka": aracPlaka,
      "aracAd": aracAd,
      "telefon": telefon,
      "koltukNo": koltukNo
    };
  }
}
