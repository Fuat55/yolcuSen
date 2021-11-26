import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yolcusen/apis/biletApi.dart';
import 'package:yolcusen/apis/seferApi.dart';
import 'package:yolcusen/helpers/custom_dialog_box.dart';
import 'package:yolcusen/helpers/loading_helper.dart';
import 'package:yolcusen/helpers/variableApp.dart';
import 'package:yolcusen/models/bilet.dart';
import 'package:yolcusen/models/sefer.dart';

class SeferOlustur extends StatefulWidget {
  final String sID, aID;

  SeferOlustur({Key? key, required this.sID, required this.aID})
      : super(key: key);
  @override
  _SeferOlusturState createState() => _SeferOlusturState();
}

class _SeferOlusturState extends State<SeferOlustur> {
  final _formKey = GlobalKey<FormState>();
  final ilkKalkis = TextEditingController();
  final yolcuSayisi = TextEditingController();
  final tarih = TextEditingController();
  final saat = TextEditingController();
  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widt = MediaQuery.of(context).size.width;
    double heig = MediaQuery.of(context).size.height;

    TextFormField inputYolcuSayisi = TextFormField(
      controller: yolcuSayisi,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Yolcu Sayısı',
        border: OutlineInputBorder(),
        icon: Icon(Icons.airline_seat_legroom_extra),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Boş geçilmez';
        }

        if (!RegExp("^[0-9]").hasMatch(value)) {
          return 'Sayı giriniz';
        }
        return null;
      },
    );

    TextFormField inputKalkis = TextFormField(
      controller: ilkKalkis,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Kalkış Yeri',
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

    TextFormField secilenTarih = TextFormField(
      controller: tarih,
      keyboardType: TextInputType.datetime,
      onTap: () async {
        DateTime? t = await showDatePicker(
          context: context,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year),
          lastDate: DateTime(DateTime.now().year + 5),
        );
        setState(() {
          tarih.text = (t!.day.toString() +
                  "/" +
                  t.month.toString() +
                  "/" +
                  t.year.toString())
              .toString();
        });
      },
      decoration: InputDecoration(
        labelText: 'Sefer Tarihi',
        border: OutlineInputBorder(),
        icon: Icon(Icons.date_range),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Boş geçilmez';
        }
        return null;
      },
    );
    TextFormField secilenSaat = TextFormField(
      controller: saat,
      keyboardType: TextInputType.datetime,
      onTap: () async {
        TimeOfDay? s = await showTimePicker(
          context: context,
          initialEntryMode: TimePickerEntryMode.dial,
          initialTime: TimeOfDay.now(),
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        setState(() {
          saat.text = s!.hour.toString() + ":" + s.minute.toString();
        });
      },
      decoration: InputDecoration(
        labelText: 'Sefer Saati',
        border: OutlineInputBorder(),
        icon: Icon(Icons.timer),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: inputKalkis,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: inputYolcuSayisi,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: secilenTarih,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: secilenSaat,
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
                                  if (_formKey.currentState!.validate()) {
                                    SeferEkle();
                                  }
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
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text('Yeni Sefer'),
              automaticallyImplyLeading: false,
            ),
            body: Center(child: body));
  }

  Future<void> SeferEkle() async {
    setState(() {
      loading = true;
    });
    Sefer yeni = new Sefer.namedCons(
        int.parse(widget.aID),
        int.parse(widget.sID),
        tarih.text,
        saat.text,
        ilkKalkis.text,
        int.parse(yolcuSayisi.text));

    await SeferApi.addSefer(yeni).then((response) {
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
                pencereId: "seferListe",
                kID: widget.sID,
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
                  kID: widget.sID);
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
                kID: widget.sID);
          });
    });
  }
}
