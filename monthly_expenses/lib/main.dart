import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:niku/niku.dart';
import 'package:niku/namespace.dart' as n;
import 'package:device_preview/device_preview.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp()
  )
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Monthly Expenses",
      home: I18n(
        child: const ReportPage()
      ),
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

class ReportPage extends StatelessWidget {
  const ReportPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: n.Button(
          const Text("Hello"),
          onPressed: () => {
            n.showDialog(context: context, builder: (_) => n.Alert.adaptive()
              ..title = Text("Hello World")
              ..content = Text("This is alert dialog written in Niku"))
          },
        )
        ..bg = Color(0xE13838CE)
        ..alignment = Alignment.center
        ..rounded = 5
        ..shadowColor = Colors.black
        ..elevation = 2
        ..color = Colors.white
        ..m = 20
      )
    );
  }
}