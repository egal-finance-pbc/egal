import 'dart:convert';
import 'dart:io';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

class API {
  String url;

  API() {
    // TODO: Make base URL address:port dynamic.
    this.url = 'http://10.0.2.2:5000/api/v1/';
  }

  Future<Token> login(String username, password) async {
    final response = await http.post(
      this.url + 'tokens/',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return Token.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  Future<bool> signup(String firstName, lastName, username, password) async {
    final response = await http.post(
      this.url + 'accounts/',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'first_name': firstName,
        'last_name': lastName,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(response.body);
    }
    return true;
  }

  Future<Me> me() async {
    var token = await FlutterSession().get('token');
    final response = await http.get(
      this.url + 'me/',
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );

    if (response.statusCode == 200) {
      return Me.fromJson(json.decode(response.body));
    }
    throw Exception(response.body);
  }

  Future<Account> account() async {
    var token = await FlutterSession().get('token');
    var me = await FlutterSession().get('publicKey');
    final response = await http.get(
      this.url + 'accounts/$me/',
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );

    if (response.statusCode == 200) {
      return Account.fromJson(json.decode(response.body));
    }
    throw Exception(response.body);
  }

  Future<List<User>> search(String q) async {
    final token = await FlutterSession().get('token');
    final query = Uri(queryParameters: {'q': q}).query;
    final response = await http.get(
      this.url + 'accounts/?' + query,
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    if (response.statusCode == 200) {
      return User.fromList(json.decode(response.body));
    }
    throw Exception(response.body);
  }
}

class User {
  final String firstName;
  final String lastName;
  final String username;
  final String publicKey;

  User({this.firstName, this.lastName, this.username, this.publicKey});

  static List<User> fromList(List<dynamic> list) {
    var users = List<User>();
    for (final item in list) {
      users.add(User(
        firstName: item['first_name'],
        lastName: item['last_name'],
        username: item['username'],
        publicKey: item['public_key'],
      ));
    }
    return users;
  }

  String fullName() {
    return '$firstName $lastName';
  }
}

class Account {
  final String balance;

  Account({this.balance});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(balance: json['balance']);
  }
}

class Me {
  final String firstName;
  final String lastName;
  final String username;
  final String publicKey;

  Me({this.firstName, this.lastName, this.username, this.publicKey});

  factory Me.fromJson(Map<String, dynamic> json) {
    return Me(
      firstName: json['first_name'],
      lastName: json['last_name'],
      username: json['username'],
      publicKey: json['public_key'],
    );
  }
}

class Token {
  final String token;

  Token({this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(token: json['token']);
  }
}
