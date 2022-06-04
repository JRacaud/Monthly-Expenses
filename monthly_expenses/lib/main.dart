import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Monthly Expenses",
      home: I18n(child: Scaffold(
        appBar: AppBar(
          title: const Text("Monthly Expenses")
        ),
        body: const Center(
          child: Text("Hello World")
        ),
      )),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', "US"),
        Locale('fr', "FR"),
      ]);
  }
}