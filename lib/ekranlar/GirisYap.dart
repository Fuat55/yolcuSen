import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yolcusen/apis/kullaniciApi.dart';
import 'package:yolcusen/ekranlar/Profil.dart';
import 'package:yolcusen/ekranlar/UyeOl.dart';
import 'package:yolcusen/helpers/custom_dialog_box.dart';
import 'package:yolcusen/helpers/loading_helper.dart';
import 'package:yolcusen/helpers/shared.dart';
import 'package:yolcusen/helpers/variableApp.dart';

class GirisYap extends StatefulWidget {
  @override
  _GirisYapState createState() => _GirisYapState();
}

class _GirisYapState extends State<GirisYap> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController kullaniciAdi = TextEditingController();
  TextEditingController sifre = TextEditingController();
  bool isChecked = false;
  bool loading = false;

  @override
  void initState() {
    Shared sh = Shared();
    sh.oku("kadi").then((value) {
      if (value.toString() != "false") {
        kullaniciAdi.text = value.toString();
        setState(() {
          isChecked = true;
        });
      }
    });
    sh.oku("sifre").then((value) {
      if (value.toString() != "false") {
        sifre.text = value.toString();
        setState(() {
          isChecked = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widt = MediaQuery.of(context).size.width;
    double heig = MediaQuery.of(context).size.height;

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
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: widt,
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: 200,
                          child: Image(
                              image: VariableApp.logoImage, fit: BoxFit.fill),
                        )),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: inputKullaniciAdi,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: inputSifre,
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          Text("Beni hatırla")
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              height: 50,
                              width: (widt - 30) / 2,
                              child: new ElevatedButton(
                                  child: Text('Giriş Yapın'),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      KullaniciKontrol();
                                    }
                                  })),
                          SizedBox(
                              height: 50,
                              width: (widt - 30) / 2,
                              child: new ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.lime)),
                                child: Text('Üye Ol'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UyeOl()),
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        )
      ],
    );

    return loading
        ? Loading_Helper()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(40, 157, 210, 100),
              leading: Icon(Icons.arrow_forward),
              title: Text("Giriş Yapın"),
            ),
            body: Container(
              child: Center(
                child: body,
              ),
            ));
  }

  Future<void> KullaniciKontrol() async {
    setState(() {
      loading = true;
    });
    await KullaniciApi.getKullanici(kullaniciAdi.text, sifre.text)
        .then((response) {
      Iterable resultList = json.decode(response.body);
      if (resultList.length > 0) {
        Shared sh = Shared();
        if (isChecked) {
          sh.ekle("kadi", kullaniciAdi.text);
          sh.ekle("sifre", sifre.text);
        } else {
          sh.sil("kadi");
          sh.sil("sifre");
        }
        setState(() {
          loading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Profil(kID: resultList.first["kullaniciId"].toString())),
        );
      } else {
        setState(() {
          loading = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                  title: "Uyarı",
                  descriptions: "Kullanıcı adı ve/veya şifre hatalı!",
                  text: "Tamam",
                  img: Image(image: VariableApp.diaImage),
                  pencereId: "bos",
                  kID: "0");
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
                pencereId: "bos",
                kID: "0");
          });
      setState(() {
        loading = false;
      });
    });
  }
}
