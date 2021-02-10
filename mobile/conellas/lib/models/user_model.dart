import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  String id;
  String first_name;
  String last_name;
  String username;
  String password;
  
  UserModel({
    this.id,
    this.first_name,
    this.last_name,
    this.username,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}