import 'package:json_annotation/json_annotation.dart';

part 'appwrite_settings.g.dart';

@JsonSerializable()
class AppwriteSettings {
  late String projectId;
  late String endpoint;

  AppwriteSettings();

  factory AppwriteSettings.fromJson(Map<String, dynamic> json) =>
      _$AppwriteSettingsFromJson(json);
  Map<String, dynamic> toJson() => _$AppwriteSettingsToJson(this);
}
