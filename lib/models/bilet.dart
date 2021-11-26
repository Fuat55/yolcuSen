class Bilet {
  int biletId = 0;
  int kullaniciId = 0;
  int seferId = 0;
  int koltukNo = 0;
  int doluMu = 0;
  String binecekYer = "55";

  Bilet(this.biletId, this.kullaniciId, this.seferId, this.koltukNo,
      this.binecekYer,this.doluMu);
  Bilet.namedCons(
      this.kullaniciId, this.seferId, this.koltukNo, this.binecekYer,this.doluMu);

  Bilet.fromJson(Map<String, dynamic> json) {
    biletId = int.parse(json["biletId"]);
    kullaniciId = int.parse(json["kullaniciId"]);
    seferId = int.parse(json["seferId"]);
    koltukNo = int.parse(json["koltukNo"]);
    binecekYer = json["binecekYer"];
    doluMu = int.parse(json["doluMu"]); 
  }

  Map<String, dynamic> toJson() {
    return {
      "biletId": biletId,
      "kullaniciId": kullaniciId,
      "seferId": seferId,
      "koltukNo": koltukNo,
      "binecekYer": binecekYer,
      "doluMu": doluMu,
    };
  }
}
