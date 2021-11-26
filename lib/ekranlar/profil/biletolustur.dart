import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yolcusen/apis/biletApi.dart';
import 'package:yolcusen/helpers/custom_dialog_box.dart';
import 'package:yolcusen/helpers/loading_helper.dart';
import 'package:yolcusen/helpers/variableApp.dart';
import 'package:yolcusen/models/bilet.dart';

class BiletOlustur extends StatefulWidget {
  final String seferId, yolcuSayisi, yolcu;

  BiletOlustur(
      {Key? key,
      required String this.seferId,
      required String this.yolcuSayisi,
      required String this.yolcu})
      : super(key: key);
  @override
  _BiletOlusturState createState() => _BiletOlusturState();
}

class _BiletOlusturState extends State<BiletOlustur> {
  final binecekYer = TextEditingController();

  List<Bilet> gelenList = new List<Bilet>.empty();

  int _value = 0;
  int koltukNo = 0;

  String koltukGoster = "";

  bool loading = false;
  bool kBilgi = false;

  @override
  void initState() {
    Liste();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widt = MediaQuery.of(context).size.width;
    double heig = MediaQuery.of(context).size.height;

    TextFormField inputBinecek = TextFormField(
      controller: binecekYer,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Binilecek Yer',
        border: OutlineInputBorder(),
        icon: Icon(Icons.bus_alert),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Boş geçilmez';
        }
        return null;
      },
    );

    ListView body = ListView(
      shrinkWrap: true,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(
                  "Koltuk Seçimi" + koltukGoster,
                ),
              ),
              Container(
                width: 60 * double.parse(widget.yolcuSayisi),
                margin: EdgeInsets.all(10),
                child: kBilgi
                    ? Text(
                        "Koltuk bilgileri alınıyor",
                        style: TextStyle(color: Colors.lime),
                      )
                    : arkaSira(int.parse(widget.yolcuSayisi)),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: inputBinecek,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        height: 50,
                        width: widt - 20,
                        child: new ElevatedButton(
                          child: Text('Kaydet'),
                          onPressed: () async {
                            if (_value != -1) {
                              BiletSatinAl();
                            }
                          },
                        )),
                  ],
                ),
              ),
            ],
          )),
        ),
      ],
    );

    return loading
        ? Loading_Helper()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(40, 157, 210, 100),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text('Bilet Oluştur'),
              automaticallyImplyLeading: false,
            ),
            body: Center(child: body));
  }

  void Liste() {
    setState(() {
      kBilgi = true;
    });
    BiletApi.getBiletFiltre(widget.seferId).then((response) {
      Iterable resultList = json.decode(response.body);
      if (resultList.length > 0) {
        setState(() {
          gelenList = resultList.map((e) => Bilet.fromJson(e)).toList();
        });
      }
    });
    setState(() {
      kBilgi = false;
    });
  }

  Widget arkaSira(int sayi) {
    return new Center(
        child: Row(
            children: gelenList
                .map(
                  (item) => new InkWell(
                      onTap: () {
                        if (item.doluMu == 0) {
                          setState(() {
                            _value = item.biletId;
                            koltukNo = item.koltukNo;
                            koltukGoster = " :" + item.koltukNo.toString();
                          });
                        } else {
                          setState(() {
                            _value = -1;
                            koltukNo = -1;
                            koltukGoster = " ";
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        color: item.doluMu == 0 ? Colors.lime : Colors.red,
                        child: Column(
                          children: [
                            Text(item.koltukNo.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                            Icon(Icons.event_seat)
                          ],
                        ),
                      )),
                )
                .toList()));
  }

  Future<void> BiletSatinAl() async {
    await BiletApi.biletGuncelle(
            _value, binecekYer.text, int.parse(widget.yolcu))
        .then((response) {
      Iterable resultList = json.decode(response.body);
      if (resultList.length > 0) {
        setState(() {
          loading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                title: "Bilgi",
                descriptions: "Sefer oluşturma işlemi başarıyla gerçekleşti",
                text: "Tamam",
                img: Image(image: VariableApp.diaImage),
                pencereId: "biletListe",
                kID: widget.yolcu,
              );
            });
      } else {
        setState(() {
          loading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                  title: "Hata",
                  descriptions: "Hata meydana geldi!",
                  text: "Tamam",
                  img: Image(image: VariableApp.diaImage),
                  pencereId: "bos",
                  kID: widget.yolcu);
            });
      }
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
                title: "Hata",
                descriptions: error.toString(),
                text: "Tamam",
                img: Image(image: VariableApp.diaImage),
                pencereId: "bos",
                kID: widget.yolcu);
          });
    });
  }
}
