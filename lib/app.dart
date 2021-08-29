import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:monthly_expenses/features/report/ui/pages/report_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  static late SharedPreferences _preferences;
  static get preferences => _preferences;

  App() {
    SharedPreferences.getInstance().then((value) => _preferences = value);
  }

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Monthly Expenses',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
        Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
      ],
      home: ReportPage(),
    );
  }
}
