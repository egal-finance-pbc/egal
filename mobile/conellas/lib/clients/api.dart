import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  String url;

  API() {
    // ignore: todo
    // TODO: Make base URL address:port dynamic.
    this.url = 'http://10.0.2.2:5000/api/v1/';
  }

  Future<Token> login(String username, password) async {
    final response = await http.post(this.url + 'tokens/',
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
    } else {
      throw Exception(response.body);
    }
  }

  Future<Account> createUser(String first, last, username, password) async {
    final response = await http.post(this.url + 'accounts/',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'first_name': first,
        'last_name': last,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return Account.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }
}

class Account {
  final String first_name;
  final String last_name;
  final String username;
  final String password;

  Account({this.first_name, this.last_name, this.username, this.password});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      first_name: json['first'],
      last_name: json['last'],
      username: json['username'],
      password: json['password'],
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
