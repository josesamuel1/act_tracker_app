import 'package:act_tracker/features/auth/domain/entities/user.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.model.g.dart';

@JsonSerializable(includeIfNull: false)
class UserModel extends UserEntity {
  const UserModel({super.id, required super.username, required super.password});

  UserModel copyWith({int? id, String? username, String? password}) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
