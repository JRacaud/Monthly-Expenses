import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    return const MaterialApp(
      title: "Monthly Expenses",
      home: ReportPage()
    );
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
              ..title = const Text("Hello World")
              ..content = const Text("This is alert dialog written in Niku"))
          },
        )
        ..bg = const Color(0xE13838CE)
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