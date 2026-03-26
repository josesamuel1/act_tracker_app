import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class ActivityEntryEntity extends Equatable {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  final String title;
  final String description;
  @JsonKey(name: 'start_time')
  final DateTime startTime;
  @JsonKey(name: 'end_time')
  final DateTime endTime;

  const ActivityEntryEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [id, userId, title, description, startTime, endTime];
}
