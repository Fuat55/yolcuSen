import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yolcusen/apis/aracApi.dart';
import 'package:yolcusen/apis/hataApi.dart';
import 'package:yolcusen/helpers/custom_dialog_box.dart';
import 'package:yolcusen/helpers/loading_helper.dart';
import 'package:yolcusen/helpers/variableApp.dart';
import 'package:yolcusen/models/arac.dart';
import 'package:yolcusen/models/hata.dart';

class HataBildir extends StatefulWidget {
  final String kID;

  HataBildir({Key? key, required this.kID}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return HataBildirState();
  }
}

class HataBildirState extends State<HataBildir> {
  final _formKey = GlobalKey<FormState>();
  final hataBaslik = TextEditingController();
  final hataAciklama = TextEditingController();

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    TextFormField inputHataBaslik = TextFormField(
      controller: hataBaslik,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Hata Başlık',
        border: OutlineInputBorder(),
        icon: Icon(Icons.error),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Boş geçilmez';
        }
        return null;
      },
    );

    TextFormField inputHataAciklama = TextFormField(
      controller: hataAciklama,
      minLines: 6,
      maxLines: null,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Hata Açıklama',
        border: OutlineInputBorder(),
        icon: Icon(Icons.description),
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
                    child: inputHataBaslik,
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: inputHataAciklama,
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
                                HataEkle();
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
              title: Text("Hata Bildir"),
            ),
            body: Container(
              color: Colors.white,
              child: Center(
                child: body,
              ),
            ));
  }

  Future<void> HataEkle() async {
    Hata yeni = new Hata.namedCons(
        hataBaslik.text, hataAciklama.text, int.parse(widget.kID));

    setState(() {
      loading = true;
    });

    await HataApi.addHata(yeni).then((response) {
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
                descriptions: "Hata kayıt işlemi başarıyla gerçekleşti",
                text: "Tamam",
                img: Image(image: VariableApp.diaImage),
                kID: widget.kID,
                pencereId: "Profil",
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
                descriptions: "Sistemsel bir hata oluştu!"+error.toString(),
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
