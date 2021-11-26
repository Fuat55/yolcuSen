import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yolcusen/ekranlar/GirisYap.dart';
import 'package:yolcusen/ekranlar/profil/aracliste.dart';
import 'package:yolcusen/ekranlar/profil/biletliste.dart';
import 'package:yolcusen/ekranlar/profil/biletolustur.dart';
import 'package:yolcusen/ekranlar/profil/hatabildir.dart';
import 'package:yolcusen/ekranlar/profil/seferliste.dart';

class Profil extends StatefulWidget {
  final String kID;


  Profil({Key? key, required this.kID}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(40, 157, 210, 100),
          leading: Icon(Icons.assignment_ind),
          title: Text('Profiliniz'),
          automaticallyImplyLeading: false,
        ),
        body:SingleChildScrollView(
          child:  Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*ButtonItem(
                "Yeni Araç", Color.fromRGBO(2, 48, 71, 100), Icons.assistant),*/
                ButtonItem("Araçlarım", Color.fromRGBO(67, 170, 139, 100),
                    Icons.airport_shuttle),
                ButtonItem("Seferler", Color.fromRGBO(33, 158, 188, 100),
                    Icons.add_road),
                ButtonItem("Biletlerim", Color.fromRGBO(251, 133, 0, 100),
                    Icons.wallet_travel),
                ButtonItem("Hata Bildir", Color.fromRGBO(243, 114, 44, 100),
                    Icons.error),
                ButtonItem(
                    "Çıkış", Color.fromRGBO(224, 36, 1, 100), Icons.exit_to_app),
              ],
            ),
          ),
        ));
  }

  Card ButtonItem(String title, Color color, IconData icon) {
    return Card(
      elevation: 1.0,
      margin: new EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(color: color),
          child: new InkWell(
              onTap: () {
                switch (title) {
                  case "Araçlarım":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AracListe(kID: widget.kID)),
                    );
                    break;
                  case "Seferler":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SeferListe(kID: widget.kID)),
                    );
                    break;
                  case "Biletlerim":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BiletListe(kID: widget.kID)),
                    );
                    break;
                  case "Hata Bildir":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HataBildir(kID: widget.kID)),
                    );
                    break;
                  case "Çıkış":
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => GirisYap()),
                          (Route<dynamic> route) => false,
                    );
                    break;
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Center(
                      child: Icon(
                        icon,
                        size: 40.0,
                        color: Colors.white,
                      )),
                  SizedBox(height: 10.0),
                  new Center(
                    child: new Text(title,
                        style:
                        new TextStyle(fontSize: 18.0, color: Colors.white)),
                  ),
                  SizedBox(height: 20.0)
                ],
              )),
        ),
    );
  }
}
