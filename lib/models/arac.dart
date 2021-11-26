class Arac {
  int aracId=0;
  String aracPlaka="55";
  String aracAd="55";
  int sahip=0;

  Arac(this.aracId, this.aracPlaka, this.sahip,this.aracAd);
  Arac.namedCons(this.aracPlaka, this.sahip, this.aracAd);

  Arac.fromJson(Map<String, dynamic> json) {
    aracId = int.parse(json["aracId"]);
    aracPlaka = json["aracPlaka"];
    aracAd = json["aracAd"];
    sahip = int.parse(json["sahip"]);

  }

  Map<String, dynamic> toJson() {
    return {
      "aracId": aracId,
      "aracPlaka": aracPlaka,
      "aracAd": aracAd,
      "sahip": sahip
    };
  }
}
