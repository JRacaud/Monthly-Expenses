// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appwrite_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppwriteSettings _$AppwriteSettingsFromJson(Map<String, dynamic> json) {
  return AppwriteSettings()
    ..projectId = json['projectId'] as String
    ..endpoint = json['endpoint'] as String;
}

Map<String, dynamic> _$AppwriteSettingsToJson(AppwriteSettings instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'endpoint': instance.endpoint,
    };
