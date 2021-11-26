import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yolcusen/apis/aracApi.dart';
import 'package:yolcusen/helpers/custom_dialog_box.dart';
import 'package:yolcusen/helpers/loading_helper.dart';
import 'package:yolcusen/helpers/variableApp.dart';
import 'package:yolcusen/models/arac.dart';

class AracEkle extends StatefulWidget {
  final String kID;

  AracEkle({Key? key, required this.kID}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AracEkleState();
  }
}

class AracEkleState extends State<AracEkle> {
  final _formKey = GlobalKey<FormState>();
  final aracPlaka = TextEditingController();
  final yolcuSayisi = TextEditingController();
  final aracAd = TextEditingController();

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    TextFormField inputPlaka = TextFormField(
      controller: aracPlaka,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Araç Plaka',
        border: OutlineInputBorder(),
        icon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Boş geçilmez';
        }
        return null;
      },
    );

    TextFormField inputAracAd = TextFormField(
      controller: aracAd,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Araç Adı',
        border: OutlineInputBorder(),
        icon: Icon(Icons.airport_shuttle),
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
          padding: EdgeInsets.all(10),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(5),
                    child: inputPlaka,
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: inputAracAd,
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(5, 15, 5, 0),
                      child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: new ElevatedButton(
                            child: Text('Kaydet'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                AracEkle();
                              }
                            },
                          ))),
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
              title: Text("Yeni Araç"),
            ),
            body: Container(
              color: Colors.white,
              child: Center(
                child: body,
              ),
            ));
  }

  Future<void> AracEkle() async {
    Arac yeni =
        new Arac.namedCons(aracPlaka.text, int.parse(widget.kID), aracAd.text);

    setState(() {
      loading = true;
    });

    await AracApi.addArac(yeni).then((response) {
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
                descriptions: "Araç kayıt işlemi başarıyla gerçekleşti",
                text: "Tamam",
                img: Image(image: VariableApp.diaImage),
                kID: widget.kID,
                pencereId: "aracListe",
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
                  kID: widget.kID,
                  pencereId: "bos");
            });
      }
    }).onError((error, stackTrace) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
                title: "Hata",
                descriptions: "Sistemsel bir hata oluştu!",
                text: "Tamam",
                img: Image(image: VariableApp.diaImage),
                kID: widget.kID,
                pencereId: "bos");
          });
      setState(() {
        loading = false;
      });
    });
  }
}
