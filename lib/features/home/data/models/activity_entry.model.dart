import 'package:act_tracker/features/home/domain/entities/activity_entry.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_entry.model.g.dart';

@JsonSerializable()
class ActivityEntryModel extends ActivityEntryEntity {
  const ActivityEntryModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.startTime,
    required super.endTime,
  });

  ActivityEntryModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return ActivityEntryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  factory ActivityEntryModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityEntryModelToJson(this);
}
