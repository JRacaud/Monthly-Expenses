import 'package:json_annotation/json_annotation.dart';

part 'AppWriteSettings.g.dart';

const String APPWRITE_KEY = "appwrite";
const String APPWRITE_PROJECT_ID_KEY = "appwrite:projectId";
const String APPWRITE_ENDPOINT_KEY = "appwrite:endpoint";

@JsonSerializable()
class AppWriteSettings {
  late String projectId;
  late String endpoint;

  AppWriteSettings(this.projectId, this.endpoint);

  factory AppWriteSettings.fromJson(Map<String, dynamic> json) =>
      _$AppWriteSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppWriteSettingsToJson(this);
}
