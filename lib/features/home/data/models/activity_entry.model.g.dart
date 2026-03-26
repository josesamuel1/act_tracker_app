// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_entry.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityEntryModel _$ActivityEntryModelFromJson(Map<String, dynamic> json) =>
    ActivityEntryModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
    );

Map<String, dynamic> _$ActivityEntryModelToJson(ActivityEntryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime.toIso8601String(),
    };
