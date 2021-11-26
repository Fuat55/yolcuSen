import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:yolcusen/ekranlar/AnaSayfa.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData.light().copyWith(
          inputDecorationTheme:
              InputDecorationTheme(border: OutlineInputBorder())),
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('tr')
      ],
      home: Anasayfa()));
}
