import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yolcusen/apis/biletApi.dart';
import 'package:yolcusen/ekranlar/Profil.dart';
import 'package:yolcusen/helpers/loading_helper.dart';
import 'package:yolcusen/models/bilet.dart';
import 'package:yolcusen/models/biletDetay.dart';

class BiletListe extends StatefulWidget {
  final String kID;

  BiletListe({Key? key, required this.kID}) : super(key: key);
  @override
  _BiletListeState createState() => _BiletListeState();
}

class _BiletListeState extends State<BiletListe> {
  List<BiletDetay> list = new List<BiletDetay>.empty();
  bool loading = false;

  @override
  void initState() {
    biletListele();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text('Biletleriniz'),
          automaticallyImplyLeading: false,
        ),
        body: loading
            ? Loading_Helper()
            : Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, position) {
                      return Card(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          list[position].aracPlaka +
                                              ", " +
                                              list[position].aracAd,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5,),
                                        Text("Tarih: " +
                                            list[position].tarih +
                                            ", Saat: " +
                                            list[position].saat),
                                        SizedBox(height: 5,),
                                        Text("Koltuk: " +
                                            list[position].koltukNo.toString() +
                                            ", Araç Sahibi: " +
                                            list[position].adSoyad),
                                        SizedBox(height: 5,),
                                        Text("Telefon: " +
                                            list[position].telefon.toString()),
                                      ],
                                    ),
                                  Flexible(fit: FlexFit.tight, child: SizedBox()),
                                  Column(
                                      children: [
                                        PopupMenuButton(
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                value: 'biletSil',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete),
                                                    SizedBox(
                                                      width: 7,
                                                    ),
                                                    Text('İptal Et')
                                                  ],
                                                ),
                                              )
                                            ];
                                          },
                                          onSelected: (String value) {
                                            actionPopUpItemSelected(value,
                                                list[position].biletId.toString());
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              )));
                    }),
              ));
  }

  void actionPopUpItemSelected(String value, String biletId) {
    String message;
    if (value == 'biletSil') {
      biletSil(biletId);
    } else {
      message = 'İşlem bulunamadı';
    }
  }

  Future<void> biletSil(String biletId) async {
    await BiletApi.biletSil(int.parse(biletId), "", int.parse(widget.kID))
        .then((response) {
      biletListele();
    });
  }

  Future<void> biletListele() async {
    setState(() {
      loading = true;
    });
    await BiletApi.getBiletlerim(widget.kID).then((response) {
      Iterable resultList = json.decode(response.body);
      setState(() {
        this.list = resultList.map((e) => BiletDetay.fromJson(e)).toList();
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
    });
  }
}
