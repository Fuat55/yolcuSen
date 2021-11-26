import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yolcusen/apis/kullaniciApi.dart';
import 'package:yolcusen/helpers/custom_dialog_box.dart';
import 'package:yolcusen/helpers/loading_helper.dart';
import 'package:yolcusen/helpers/variableApp.dart';
import 'package:yolcusen/models/kullanici.dart';

class UyeOl extends StatefulWidget {
  @override
  _UyeOlState createState() => _UyeOlState();
}

class _UyeOlState extends State<UyeOl> {
  final _formKey = GlobalKey<FormState>();
  final adSoyad = TextEditingController();
  final kullaniciAdi = TextEditingController();
  final telefon = TextEditingController();
  final sifre = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    TextFormField inputAdSoyad = TextFormField(
      controller: adSoyad,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Ad Soyad',
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

    TextFormField inputKullaniciAdi = TextFormField(
      controller: kullaniciAdi,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'E-Posta (Kullanıcı Adı)',
        border: OutlineInputBorder(),
        icon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Boş geçilmez';
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return 'Geçersiz adres';
        }
        return null;
      },
    );

    TextFormField inputTelefon = TextFormField(
      controller: telefon,
      keyboardType: TextInputType.text,
      maxLength: 11,
      decoration: InputDecoration(
        labelText: 'Telefon',
        border: OutlineInputBorder(),
        icon: Icon(Icons.phone),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Boş geçilmez';
        }
        return null;
      },
    );

    TextFormField inputSifre = TextFormField(
      controller: sifre,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: 'Sifre',
        border: OutlineInputBorder(),
        icon: Icon(Icons.password),
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
                    child: inputAdSoyad,
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: inputKullaniciAdi,
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: inputSifre,
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    child: inputTelefon,
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: new ElevatedButton(
                            child: Text('Kaydol'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                KullaniciEkle();
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
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text("Üyelik Formu"),
            ),
            body: Container(
              color: Colors.white,
              child: Center(
                child: body,
              ),
            ));
  }

  Future<void> KullaniciEkle() async {
    setState(() {
      loading = true;
    });

    Kullanici yeni = new Kullanici.namedCons(
        adSoyad.text, telefon.text, kullaniciAdi.text, sifre.text);

    await KullaniciApi.getKontrol(yeni.kullaniciAdi).then((response) {
      Iterable resultList = json.decode(response.body);
      if (resultList.length > 0) {
        setState(() {
          loading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                  title: "Uyarı",
                  descriptions: "Kullanıcı sistemde kayıtlıdır!",
                  text: "Tamam",
                  img: Image(image: VariableApp.diaImage),
                  pencereId: "bos",
                  kID: "0");
            });
      } else {
        KullaniciApi.addKullanici(yeni).then((response) {
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
                      descriptions: "Üyelik işlemi başarıyla gerçekleşti",
                      text: "Tamam",
                      img: Image(image: VariableApp.diaImage),
                      pencereId: "GirisYap",
                      kID: "0");
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
                      descriptions: "Sistemsel bir hata oluştu!",
                      text: "Tamam",
                      img: Image(image: VariableApp.diaImage),
                      pencereId: "bos",
                      kID: "0");
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
                    descriptions: "Sistemsel bir hata oluştu!",
                    text: "Tamam",
                    img: Image(image: VariableApp.diaImage),
                    pencereId: "bos",
                    kID: "0");
              });
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
                descriptions: "Sistemsel bir hata oluştu!",
                text: "Tamam",
                img: Image(image: VariableApp.diaImage),
                pencereId: "bos",
                kID: "0");
          });
      setState(() {
        loading = false;
      });
    });
  }
}
