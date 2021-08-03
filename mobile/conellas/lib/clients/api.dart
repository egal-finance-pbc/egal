import 'dart:convert';
import 'dart:io';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class API {
  String url;

  API() {
    // TODO: Make base URL address:port dynamic.
    this.url = 'http://10.0.2.2:5000/api/v1/';
  }

  Future<Token> login(String username, passcode) async {
    final response = await http.post(
      this.url + 'tokens/',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'passcode': passcode,
      }),
    );

    if (response.statusCode == 200) {
      return Token.fromJson(jsonDecode(response.body));
    }
    throw APIError.fromResponse(response);
  }

  Future<bool> signup(String phoneNumber, username, passcode) async {
    final response = await http.post(
      this.url + 'accounts/',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'phone_number': phoneNumber,
        'username': username,
        'passcode': passcode,
      }),
    );

    if (response.statusCode != 201) {
      throw APIError.fromResponse(response);
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
    throw APIError.fromResponse(response);
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
    throw APIError.fromResponse(response);
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
    throw APIError.fromResponse(response);
  }

  Future<void> pay(String dest, double amount, String desc) async {
    final token = await FlutterSession().get('token');
    var body = <String, dynamic>{
      'amount': amount,
      'destination': dest,
    };
    if (desc.isNotEmpty) {
      body['description'] = desc;
    }
    final response = await http.post(
      this.url + 'payments/',
      headers: <String, String>{
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Token $token',
      },
      body: jsonEncode(body),
    );
    if (response.statusCode != 201) {
      throw APIError.fromResponse(response);
    }
  }

  Future<List<Payment>> payments() async {
    var token = await FlutterSession().get('token');
    final response = await http.get(
      this.url + 'payments/',
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );

    if (response.statusCode == 200) {
      return Payment.fromList(json.decode(response.body));
    }
    throw Exception(response.body);
  }
}

class Payment {
  final String amount;
  final String description;
  final User source;
  final User destination;

  Payment({this.amount, this.description, this.source, this.destination});

  static List<Payment> fromList(List<dynamic> list) {
    var payments = List<Payment>();
    for (final item in list) {
      payments.add(Payment(
        amount: item['amount'],
        description: item['description'],
        source: User.fromJson(item['source']),
        destination: User.fromJson(item['destination']),
      ));
    }
    return payments;
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

  factory User.fromJson(Map<String, dynamic> item) {
    return User(
      firstName: item['first_name'],
      lastName: item['last_name'],
      username: item['username'],
      publicKey: item['public_key'],
    );
  }

  String fullName() {
    return '$firstName $lastName';
  }
}

class APIError implements Exception {
  //final int statusCode;
  final http.Response message;

  APIError({this.message});

  factory APIError.fromResponse(http.Response response) {
    return APIError(message: response);
  }

  Widget title() {
    switch (this.message.statusCode) {
      case HttpStatus.badRequest:
        return Container(
          child: Text("Invalid Request"),
        );
      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        return Container(
          child: Text("Unauthorized access"),
        );
      case HttpStatus.notFound:
        return Container(
          child: Text("Not found"),
        );
      case HttpStatus.internalServerError:
        return Container(
          child: Text("Something went wrong"),
        );
      default:
        return Container(
            child: Text("Error During Communication : response.statusCode"));
    }
  }

  Widget content() {
    switch (this.message.statusCode) {
      case HttpStatus.badRequest:
        return Container(
          child: Text("Specific field is not filled"),
        );
      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        return Container(
          child: Text(
              "Detail: access is not authorized, authentication token is missing"),
        );
      case HttpStatus.notFound:
        return Container(
          child:
              Text("Detail: the page you are trying to access cannot be found"),
        );
      case HttpStatus.internalServerError:
        return Container(
          child: Text("Detail: something went wrong"),
        );
      default:
        return Container(
            child: Text("Error During Communication : response.statusCode"));
    }
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
