import 'dart:convert';
import 'dart:io';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  String url;
  String urlStellar;

  API() {
    // TODO: Make base URL address:port dynamic.
    //URL GENERAL
    this.url = 'http://54.198.108.195/api/v1/';
    this.urlStellar = 'http://api.coinlayer.com/api/live?access_key=';
  }

  Future<Token> login(String username, password) async {
    final response = await http.post(
      Uri.parse(this.url + 'tokens/'),
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

  Future<bool> signup(String phone, username, names, patSurname, matSurname, password, country) async {
    final response = await http.post(
      Uri.parse(this.url + 'accounts/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'phone': phone,
        'username': username,
        'names': names,
        'paternal_surname': patSurname,
        'maternal_surname': matSurname,
        'password': password,
        'country': country,
      }),
    );

    if (response.statusCode != 201) {
      print(country);
      throw APIError.fromResponse(response);
    }
    return true;
  }

  Future<Me> me() async {
    var token = await FlutterSession().get('token');
    final response = await http.get(
      Uri.parse(this.url + 'me/'),
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );

    var body = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      return Me.fromJson(json.decode(body));
    }
    throw APIError.fromResponse(response);
  }

  Future<bool> updateAccount(String city, String state) async {
    var token = await FlutterSession().get('token');
    var me = await FlutterSession().get('publicKey');

    final response =  await http.put(
      Uri.parse(this.url + 'accounts/$me/update/'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Token $token',
        'Content-Type': 'application/json',
      },

      body: jsonEncode(<String, String>{
        'city': city,
        'state': state,
      }),
    );

    if (response.statusCode != 200){
      throw APIError.fromResponse(response);
    }
    return true;
  }

  Future<bool> updatePhoto(File photo) async {
    var token = await FlutterSession().get('token');
    var me = await FlutterSession().get('publicKey');
    final response = await http.MultipartRequest('PUT',
      Uri.parse(this.url + 'accounts/$me/photo/'),);

    Map<String, String> headers = {HttpHeaders.authorizationHeader: 'Token $token', 'Content-Type': 'application/json'};

    response.headers.addAll(headers);
    response.files.add(await http.MultipartFile.fromBytes(
        'photo', await photo.readAsBytesSync(),
        filename: photo.path.split('/').last,
        contentType: MediaType('png', 'jpeg')));

    var request = await response.send();

    if (request.statusCode == 200) {
      print('Uploaded!');
    }else{
      print('Failed!');
      print(request.statusCode);
    }
    return true;
  }

  Future<Account> account() async {
    var token = await FlutterSession().get('token');
    var me = await FlutterSession().get('publicKey');
    final response = await http.get(
      Uri.parse(this.url + 'accounts/$me/'),
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );

    if (response.statusCode == 200) {
      return Account.fromJson(json.decode(response.body));
    }
    throw APIError.fromResponse(response);
  }

  Future<Saving> saving() async {
    var token = await FlutterSession().get('token');
    var me = await FlutterSession().get('savingKey');
    final response = await http.get(
      Uri.parse(this.url + 'accounts/$me/'),
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );

    if (response.statusCode == 200) {
      return Saving.fromJson(json.decode(response.body));
    }
    throw APIError.fromResponse(response);
  }

  Future<List<User>> search(String q) async {
    final token = await FlutterSession().get('token');
    final query = Uri(queryParameters: {'q': q}).query;
    final response = await http.get(
      Uri.parse(this.url + 'accounts/?' + query),
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );
    var body = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      return User.fromList(json.decode(body));
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
      Uri.parse(this.url + 'payments/'),
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
      Uri.parse(this.url + 'payments/'),
      headers: {HttpHeaders.authorizationHeader: 'Token $token'},
    );

    var body = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      return Payment.fromList(json.decode(body));
    }
    throw APIError.fromResponse(response);
  }

  Future<CountryBalance> price() async {
    final response = await http.get(
        Uri.parse(this.urlStellar+'2b38edff0cca9b23fc093f22857850c1'),
        headers: {'Content-Type': 'application/json'}
    );

    if (response.statusCode == 200) {
      return CountryBalance.fromJson(json.decode(response.body));
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
  final String names;
  final String paternal_surname;
  final String maternal_surname;
  final String username;
  final String publicKey;
  final String savingKey;
  final String phone;


  User({this.names, this.paternal_surname, this.maternal_surname, this.username, this.publicKey, this.savingKey, this.phone});

  static List<User> fromList(List<dynamic> list) {
    var users = List<User>();
    for (final item in list) {
      users.add(User(
        names: item['names'],
        paternal_surname: item['paternal_surname'],
        maternal_surname: item['maternal_surname'],
        username: item['username'],
        publicKey: item['public_key'],
        savingKey: item['saving_key'],
        phone: item["phone"],

      ));
    }
    return users;
  }

  factory User.fromJson(Map<String, dynamic> item) {
    return User(
      names: item['names'],
      paternal_surname: item['paternal_surname'],
      maternal_surname: item['maternal_surname'],
      username: item['username'],
      publicKey: item['public_key'],
      savingKey: item['saving_key'],
      phone: item["phone"],
    );
  }

  String fullName() {
    return '$names $paternal_surname $maternal_surname';
  }
}

class APIError implements Exception {
  final http.Response message;

  APIError({this.message});

  factory APIError.fromResponse(http.Response response) {
    return APIError(message: response);
  }

  String title() {
    switch (this.message.statusCode) {
      case HttpStatus.badRequest:
        return "Invalid Request";
      case HttpStatus.unauthorized:
        return "No unauthorized";
      case HttpStatus.forbidden:
        return "Unauthorized access";
      case HttpStatus.notFound:
        return "Not found";
      case HttpStatus.internalServerError:
        return "Something went wrong";
      default:
        return "Error During Communication : response.statusCode";
    }
  }

  String content() {
    final Map<String, dynamic> detail = jsonDecode(message.body);
    final username = detail['username'].toString().replaceAll("[", "").replaceAll("]", "");
    final password = detail['password'].toString().replaceAll("[", "").replaceAll("]", "");
    final non_field_errors = detail['non_field_errors'].toString().replaceAll("[", "").replaceAll("]", "");

    getError() {
      if(username != 'null' && password == 'null'){
        return username;
      }else
      if(password != 'null' && username == 'null'){
        return password;
      }else
      if(username != 'null' && password != 'null'){
        return username+' '+password;
      }else
        return non_field_errors;
    }

    switch (this.message.statusCode) {
      case HttpStatus.badRequest:
        return getError();

      case HttpStatus.unauthorized:
      case HttpStatus.forbidden:
        return detail['detail'];
      case HttpStatus.notFound:
        return detail['detail'];
      case HttpStatus.internalServerError:
        return detail['detail'];
      default:
        return "Error During Communication : response.statusCode";
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

class Saving {
  final String balance;

  Saving({this.balance});

  factory Saving.fromJson(Map<String, dynamic> json) {
    return Saving(balance: json['balance']);
  }
}

class Me {
  final String names;
  final String paternal_surname;
  final String maternal_surname;
  final String username;
  final String publicKey;
  final String savingKey;
  final String phone;
  final String country;
  final String city;
  final String state;
  final String photo;

  Me({this.names, this.paternal_surname, this.maternal_surname, this.username, this.publicKey, this.savingKey, this.phone, this.country, this.city, this.state, this.photo});

  factory Me.fromJson(Map<String, dynamic> json) {
    return Me(
      names: json['names'],
      paternal_surname: json['paternal_surname'],
      maternal_surname: json['maternal_surname'],
      username: json['username'],
      publicKey: json['public_key'],
      savingKey: json['saving_key'],
      phone: json['phone'],
      country: json['country'],
      city: json['city'],
      state: json['state'],
      photo: json['photo'],
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

  static final _auth = LocalAuthentication();

  static Future<bool> checkBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await checkBiometrics();
    if (!isAvailable) return false;
    try {
      return await _auth.authenticate(
        localizedReason: 'Scan Fingerprint to Authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
      );
    } catch (e) {
      return false;
    }
  }

  static Future<void> loginWithBiometrics(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user') ?? '';
    var password = prefs.getString('passcode') ?? '';
    print(user);
    print(password);

    try{
      if(user != ''){
        var authenticateWithBiometrics = await authenticate();
        if(authenticateWithBiometrics) {
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

CountryBalance countryBalanceFromJson(String str) => CountryBalance.fromJson(json.decode(str));

String countryBalanceToJson(CountryBalance data) => json.encode(data.toJson());

class CountryBalance {
  CountryBalance({
    this.success,
    this.target,
    //this.rates,
  });

  bool success;
  String target;
  //Rates rates;

  factory CountryBalance.fromJson(Map<String, dynamic> json) => CountryBalance(
    success: json["success"],
    target: json["target"],
    //rates: Rates.fromJson(json["rates"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "target": target,
    //"rates": rates.toJson(),
  };
}

/*class Rates {
    Rates({
        this.xlm,
    });

    double xlm;

    factory Rates.fromJson(Map<String, dynamic> json) => Rates(
        xlm: json["XLM"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "XLM": xlm,
    };
}*/


