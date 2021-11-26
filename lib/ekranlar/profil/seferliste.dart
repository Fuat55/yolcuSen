import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yolcusen/apis/seferApi.dart';
import 'package:yolcusen/ekranlar/Profil.dart';
import 'package:yolcusen/ekranlar/profil/biletolustur.dart';
import 'package:yolcusen/helpers/loading_helper.dart';
import 'package:yolcusen/models/sefer.dart';

class SeferListe extends StatefulWidget {
  final String kID;

  SeferListe({Key? key, required this.kID}) : super(key: key);
  @override
  _SeferListeState createState() => _SeferListeState();
}

class _SeferListeState extends State<SeferListe> {
  List<Sefer> list = new List<Sefer>.empty();
  final _formKey = GlobalKey<FormState>();
  final tarih = TextEditingController();
  bool loading = false;
  bool listYokMu = false;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextFormField secilenTarih = TextFormField(
      controller: tarih,
      keyboardType: TextInputType.datetime,
      onTap: () async {
        DateTime? t = await showDatePicker(
          context: context,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.now(),
          selectableDayPredicate: (DateTime day) {
            return day.difference(DateTime.now()).inDays<7;
          },
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
      )
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(40, 157, 210, 100),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profil(kID: widget.kID)),
              );
            },
          ),
          title: Text('Seferler'),
          automaticallyImplyLeading: false,
        ),
        body: loading
            ? Loading_Helper()
            : Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.only(top: 15.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                                margin: EdgeInsets.only(right: 5.0),
                                child: secilenTarih),
                          ),
                          Expanded(
                              flex: 2,
                              child: SizedBox(
                                  height: 60,
                                  child: new ElevatedButton(
                                    child: Text('Listele'),
                                    onPressed: () async {
                                      seferListele(tarih.text);
                                    },
                                  ))),
                        ],
                      ),
                    ),
                    Divider(),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, position) {
                          return listYokMu
                              ? Card(child: Text("adadad"))
                              : Card(
                                  child: ListTile(
                                    title:
                                        Text(list[position].adSoyad.toString()),
                                    subtitle: Text(list[position].saat +
                                        ", " +
                                        list[position].tarih),
                                    trailing: PopupMenuButton(
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem(
                                            value: 'seferSil',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Text('Sil')
                                              ],
                                            ),
                                            enabled: widget.kID ==
                                                list[position]
                                                    .seferSahip
                                                    .toString(),
                                          ),
                                          PopupMenuItem(
                                            value: 'biletAl',
                                            child: Row(
                                              children: [
                                                Icon(Icons.wallet_travel),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Text('Bilet Oluştur')
                                              ],
                                            ),
                                            enabled: widget.kID !=
                                                list[position]
                                                    .seferSahip
                                                    .toString(),
                                          )
                                        ];
                                      },
                                      onSelected: (String value) {
                                        actionPopUpItemSelected(value,
                                            list[position].seferId.toString(),list[position].yolcuSayisi.toString());
                                      },
                                    ),
                                  ),
                                );
                        }),
                  ],
                ),
              ));
  }

  void actionPopUpItemSelected(String value, String seferId,String yolcuSayisi) {
    String message;
    if (value == 'seferSil') {
      seferSil(seferId);
      seferListele(tarih.text);
    }else if(value=='biletAl'){
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BiletOlustur(seferId: seferId,yolcuSayisi:yolcuSayisi,yolcu: widget.kID,)),
      );
    } else {
      message = 'İşlem bulunamadı';
    }
  }

  void seferSil(String seferId) {
    SeferApi.seferSil(seferId).then((response) {});
  }

  Future<void> seferListele(String tarih) async {
    setState(() {
      loading = true;
    });
    await SeferApi.getSeferTarih(tarih).then((response) {
      Iterable resultList = json.decode(response.body);
      setState(() {
        this.list = resultList.map((e) => Sefer.fromJson(e)).toList();
        resultList.length > 0 ? listYokMu = false : listYokMu = true;
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        listYokMu = true;
        loading = false;
      });
    });
  }
}
