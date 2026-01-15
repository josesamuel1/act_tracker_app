import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class UserEntity extends Equatable {
  @JsonKey(includeToJson: false)
  final int? id;
  final String username;
  @JsonKey(name: 'password_hash')
  final String password;

  const UserEntity({this.id, required this.username, required this.password});

  @override
  List<Object?> get props => [id, username, password];
}
