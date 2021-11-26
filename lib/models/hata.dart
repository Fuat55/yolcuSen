class Hata {
  int hataId=0;
  String baslik="";
  String aciklama="";
  int hataEkleyen=0;


  Hata(this.hataId, this.baslik, this.aciklama,this.hataEkleyen);
  Hata.namedCons( this.baslik, this.aciklama,this.hataEkleyen);

  Hata.fromJson(Map<String, dynamic> json) {
    hataId = int.parse(json["hataId"]);
    baslik = json["baslik"];
    aciklama = json["aciklama"];
    hataEkleyen = int.parse(json["hataEkleyen"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "hataId": hataId,
      "baslik": baslik,
      "aciklama": aciklama,
      "hataEkleyen": hataEkleyen,

    };
  }
}
