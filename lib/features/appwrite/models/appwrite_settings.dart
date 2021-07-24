import 'package:json_annotation/json_annotation.dart';

part 'appwrite_settings.g.dart';

@JsonSerializable()
class AppwriteSettings {
  AppwriteSettings();

  factory AppwriteSettings.fromJson(Map<String, dynamic> json) =>
      _$AppwriteSettingsFromJson(json);

  late String endpoint;
  late String projectId;

  Map<String, dynamic> toJson() => _$AppwriteSettingsToJson(this);
}
