import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import 'config/AppWriteSettings.dart';

const String APP_SETTINGS = "app_settings.json";

Client appwrite = Client();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset(APP_SETTINGS);
  var appwriteSettings =
      AppWriteSettings.fromJson(GlobalConfiguration().get(APPWRITE_KEY));

  appwrite
      .setProject(appwriteSettings.projectId)
      .setEndpoint(appwriteSettings.endpoint)
      .setSelfSigned();

  runApp(Finance());
}

class Finance extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Finance',
        home: Scaffold(
          body:
              Text(GlobalConfiguration().getDeepValue(APPWRITE_PROJECT_ID_KEY)),
        ));
  }
}
