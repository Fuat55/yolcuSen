import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yolcusen/apis/aracApi.dart';
import 'package:yolcusen/ekranlar/Profil.dart';
import 'package:yolcusen/ekranlar/profil/aracekle.dart';
import 'package:yolcusen/ekranlar/profil/seferolustur.dart';
import 'package:yolcusen/helpers/loading_helper.dart';
import 'package:yolcusen/models/arac.dart';

class AracListe extends StatefulWidget {
  final String kID;

  AracListe({Key? key, required this.kID}) : super(key: key);

  @override
  _AracListeState createState() => _AracListeState();
}

class _AracListeState extends State<AracListe> {
  List<Arac> list = new List<Arac>.empty();
  bool loading = false;

  @override
  void initState() {
    aracListele();
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
          title: Text('Araçlarınız'),
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AracEkle(kID: widget.kID)),
            );
          },
          child: Icon(Icons.add),
        ),
        body: loading
            ? Loading_Helper()
            : Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, position) {
                      return Card(
                        child: ListTile(
                          title: Text(list[position].aracAd),
                          subtitle: Text(list[position].aracPlaka),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: 'seferEkle',
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_road),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Text('Sefer Ekle')
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'aracSil',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Text('Sil')
                                    ],
                                  ),
                                )
                              ];
                            },
                            onSelected: (String value) {
                              actionPopUpItemSelected(
                                  value, list[position].aracId.toString());
                            },
                          ),
                        ),
                      );
                    }),
              ));
  }

  void actionPopUpItemSelected(String value, String aracId) {
    String message;
    if (value == 'seferEkle') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SeferOlustur(sID: widget.kID, aID: aracId)),
      );
    } else if (value == 'aracSil') {
      aracSil(aracId);
    } else {
      message = 'İşlem bulunamadı';
    }
  }

  Future<void> aracSil(String aracId) async{
    await AracApi.aracSil(aracId).then((response) {
      aracListele();
    });
  }

  Future<void> aracListele() async {
    setState(() {
      loading = true;
    });
    await AracApi.getAracFiltre(widget.kID).then((response) {
      Iterable resultList = json.decode(response.body);
      setState(() {
        this.list = resultList.map((e) => Arac.fromJson(e)).toList();
        loading = false;
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
    });
  }
}
