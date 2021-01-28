import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int id;
  String firstname;
  String lastname;
  String username;
  String password;
  
  UserModel({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}