import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import 'config/AppWriteSettings.dart';
import 'models/Report.dart';
import 'services/LocalReportService.dart';
import 'widgets/HomePage.dart';

const String APP_SETTINGS = "app_settings.json";

Client appwrite = Client();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializeAppwrite();
  var app = await initializeApplication();

  runApp(app);
}

void initializeAppwrite() async {
  await GlobalConfiguration().loadFromAsset(APP_SETTINGS);
  var appwriteSettings =
      AppWriteSettings.fromJson(GlobalConfiguration().get(APPWRITE_KEY));

  appwrite
      .setProject(appwriteSettings.projectId)
      .setEndpoint(appwriteSettings.endpoint)
      .setSelfSigned();
}

Future<Finance> initializeApplication() async {
  var service = LocalReportService();
  var report = await service.getReport(DateTime.now());

  return Finance(report);
}

class Finance extends StatefulWidget {
  late final Report report;

  Finance(this.report);

  @override
  State<StatefulWidget> createState() => _FinanceState(report);
}

class _FinanceState extends State {
  late Report report;

  _FinanceState(this.report);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Finance', home: HomePage(report));
  }
}
