class Sefer {
  int seferId = 0;
  int aracId = 0;
  int seferSahip = 0;
  String tarih = "55";
  String adSoyad = "55";
  String saat = "55";
  String yer = "55";
  int yolcuSayisi = 4;

  Sefer(this.seferId, this.aracId, this.seferSahip, this.tarih, this.saat,
      this.yer,this.yolcuSayisi);
  Sefer.namedCons(
      this.aracId, this.seferSahip, this.tarih, this.saat, this.yer,this.yolcuSayisi);

  Sefer.fromJson(Map<String, dynamic> json) {
    seferId = int.parse(json["seferId"]);
    aracId = int.parse(json["aracId"]);
    seferSahip = int.parse(json["seferSahip"]);
    tarih = json["tarih"];
    saat = json["saat"];
    yer = json["yer"];
    adSoyad = json["adSoyad"];
    yolcuSayisi = int.parse(json["yolcuSayisi"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "seferId": seferId,
      "aracId": aracId,
      "seferSahip": seferSahip,
      "tarih": tarih,
      "saat": saat,
      "yer": yer,
      "adSoyad": adSoyad,
      "yolcuSayisi": yolcuSayisi
    };
  }
}
