class Kullanici {
  int kullaniciId=0;
  String adSoyad="";
  String telefon="";
  String kullaniciAdi="";
  String sifre="";


  Kullanici(this.kullaniciId, this.adSoyad, this.telefon, this.kullaniciAdi,this.sifre);
  Kullanici.namedCons(this.adSoyad, this.telefon, this.kullaniciAdi,this.sifre);

  Kullanici.fromJson(Map<String, dynamic> json) {
    kullaniciId = int.parse(json["kullaniciId"]);
    adSoyad = json["adSoyad"];
    telefon = json["telefon"];
    kullaniciAdi = json["kullaniciAdi"];
    sifre = json["sifre"];
  }

  Map<String, dynamic> toJson() {
    return {
      "kullaniciId": kullaniciId,
      "adSoyad": adSoyad,
      "telefon": telefon,
      "kullaniciAdi": kullaniciAdi,
      "sifre": sifre
    };
  }
}
