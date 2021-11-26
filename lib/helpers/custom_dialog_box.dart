import 'package:flutter/material.dart';
import 'package:yolcusen/ekranlar/GirisYap.dart';
import 'package:yolcusen/ekranlar/Profil.dart';
import 'package:yolcusen/ekranlar/profil/aracliste.dart';
import 'package:yolcusen/ekranlar/profil/biletliste.dart';
import 'package:yolcusen/ekranlar/profil/seferliste.dart';
import 'package:yolcusen/helpers/variableApp.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text, pencereId;
  final Image img;

  final String kID;

  const CustomDialogBox(
      {Key? key,
      required this.title,
      required this.descriptions,
      required this.text,
      required this.img,
      required this.pencereId,
      required this.kID})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VariableApp.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: VariableApp.padding,
              top: VariableApp.avatarRadius + VariableApp.padding,
              right: VariableApp.padding,
              bottom: VariableApp.padding),
          margin: EdgeInsets.only(top: VariableApp.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(VariableApp.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          switch (widget.pencereId) {
                            case "GirisYap":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GirisYap()),
                              );
                              break;
                            case "Profil":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Profil(kID: widget.kID)),
                              );
                              break;
                            case "aracListe":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AracListe(kID: widget.kID)),
                              );
                              break;
                            case "seferListe":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SeferListe(kID: widget.kID)),
                              );
                              break;
                            case "biletListe":
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BiletListe(kID: widget.kID)),
                              );
                              break;
                            default:
                              Navigator.of(context).pop();
                              break;
                          }
                        },
                        child: Text(
                          widget.text,
                          style: TextStyle(fontSize: 18),
                        )),
                  )),
            ],
          ),
        ),
        Positioned(
          left: VariableApp.padding,
          right: VariableApp.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: VariableApp.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(VariableApp.avatarRadius)),
                child: widget.img),
          ),
        ),
      ],
    );
  }
}
