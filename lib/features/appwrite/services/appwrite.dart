import 'package:appwrite/appwrite.dart';
import 'package:finance/config/app_constants.dart';
import 'package:finance/features/appwrite/models/appwrite_settings.dart';
import 'package:global_configuration/global_configuration.dart';

class Appwrite {
  static final _instance = Client();
  static var _isInitialized = false;

  static Client get() {
    if (!_isInitialized) _init();

    return _instance;
  }

  static void _init() async {
    await GlobalConfiguration().loadFromAsset(appSettingsFilename);
    var appwriteSettings =
        AppwriteSettings.fromJson(GlobalConfiguration().get(appwriteKey));

    _instance
        .setProject(appwriteSettings.projectId)
        .setEndpoint(appwriteSettings.endpoint)
        .setSelfSigned();

    _isInitialized = true;
  }
}
