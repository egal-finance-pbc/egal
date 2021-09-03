import 'dart:convert';
import 'dart:io';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    throw APIError.fromResponse(response);
  }

  /*Future<void> saveData(username, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  static Future<API> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var username = prefs.getString('username');
    var password = prefs.getString('password');
  }*/

  Future<bool> signup(String phone, username, password) async {
    final response = await http.post(
      this.url + 'accounts/',
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'phone': phone,
        'username': username,
        'password': password,
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
    throw APIError.fromResponse(response);
  }
}

class Payment {
  final String amount;
  final String description;
  final String date;
  final User source;
  final User destination;

  Payment({this.amount, this.description, this.date, this.source, this.destination});

  static List<Payment> fromList(List<dynamic> list) {
    var payments = List<Payment>();
    for (final item in list) {
      payments.add(Payment(
        amount: item['amount'],
        description: item['description'],
        date: item['date'],
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
    final Map<String, dynamic> detail = jsonDecode(message.body);
    final username = detail['username'].toString().replaceAll("[", "").replaceAll("]", "");
    final password = detail['password'].toString().replaceAll("[", "").replaceAll("]", "");
    final non_field_errors = detail['non_field_errors'].toString().replaceAll("[", "").replaceAll("]", "");

    getError(){
      if(username != 'null' && password == 'null'){
        return Text(username);
      }else
          if(password != 'null' && username == 'null'){
            return Text(password);
          }else
            if(username != 'null' && password != 'null'){
              return Text(username+' '+password);
            }else
              return Text(non_field_errors);
    }

    switch (this.message.statusCode) {
      case HttpStatus.badRequest:
        return Container(
          child: getError()
        );
      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        return Container(
          child: Text(detail['detail']),
        );
      case HttpStatus.notFound:
        return Container(
          child: Text(detail['detail']),
        );
      case HttpStatus.internalServerError:
        return Container(
          child: Text(detail['detail']),
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

class FingerprintAPI {

  static Future<void> deleteSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  /*static Future<SessionParams> getSession() async {
    var prefs = await SharedPreferences.getInstance();

  }*/

  static final _auth = LocalAuthentication();

  static Future<bool> checkBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  /*static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return <BiometricType>[];
    }
  }*/

  static Future<bool> authenticate() async {
    final isAvailable = await checkBiometrics();
    if (!isAvailable) return false;

    try {
      return await _auth.authenticateWithBiometrics(
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } catch (e) {
      return false;
    }
  }

  static Future<void> loginWithBiometrics(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    var authenticateWithBiometrics = await authenticate();
    var user = prefs.getString('user') ?? '';
    var password = prefs.getString('passcode') ?? '';
    print(user);
    print(password);

    try{
      if(user != '' && password != ''){
        if (authenticateWithBiometrics) {
          Navigator.pushNamed(context, '/navigatorBar');
          }
      }else{
        print('You need to sign in at least once before using fingerprint');
        _fingerprintAlert(context);
      }
    }catch (e) {
      print('something went wrong');
    }
  }

  static _fingerprintAlert(BuildContext context){
    showDialog(
        context: context,
        builder: (context)
        {
          return AlertDialog(
            title: Text('Fingerprint Authentication'),
            content: Text('You need to sign in at least once before using fingerprint'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    },
                  child: Text('Ok')
              ),
            ],
            elevation: 24.0,
            backgroundColor: Color(0xFFFFFFFF),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)
            ),
          );
        },
    );
  }

}

