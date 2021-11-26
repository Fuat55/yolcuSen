import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yolcusen/ekranlar/GirisYap.dart';

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  var assetsImage = new AssetImage('assets/images/splash.png');
  bool _isConnected=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: SizedBox(
            child: Image(image: assetsImage, fit: BoxFit.scaleDown),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  void initState() {
    super.initState();

    _checkInternetConnection().then((value){

      if(_isConnected){
        Future.delayed(Duration(milliseconds: 2000), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => GirisYap()),
          );
        });
      }else{

      }
    });



  }

  Future<void> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('yolcusen.fuatsengul.net');
      if (response.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
      }else{
        setState(() {
          _isConnected = false;
        });
      }
    } on SocketException catch (err) {
      setState(() {
        _isConnected = false;
      });
      print(err);
    }
  }
}
