import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  String url;

  API() {
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

  Future<Account> signUp(String first_name, last_name, username, password) async {
    final response = await http.post(this.url + 'accounts/',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'first_name': first_name,
        'last_name': last_name,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return Account.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(response.body);
    }
  }
}

class Account {
  final String firstName;
  final String lastName;
  final String username;
  final String password;

  Account({this.firstName, this.lastName, this.username, this.password});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      firstName: json['firstName'],
      lastName: json['lastName'],
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
