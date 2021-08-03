// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Sign Up`
  String get simpleText {
    return Intl.message(
      'Sign Up',
      name: 'simpleText',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get simpleText2 {
    return Intl.message(
      'Sign In',
      name: 'simpleText2',
      desc: '',
      args: [],
    );
  }

  /// `Missing first name`
  String get simpleText3 {
    return Intl.message(
      'Missing first name',
      name: 'simpleText3',
      desc: '',
      args: [],
    );
  }

  /// `Minimum 4 characters for FirstName`
  String get simpleText4 {
    return Intl.message(
      'Minimum 4 characters for FirstName',
      name: 'simpleText4',
      desc: '',
      args: [],
    );
  }

  /// `No numbers and special characters`
  String get simpleText5 {
    return Intl.message(
      'No numbers and special characters',
      name: 'simpleText5',
      desc: '',
      args: [],
    );
  }

  /// `At least 1 upper case`
  String get simpleText6 {
    return Intl.message(
      'At least 1 upper case',
      name: 'simpleText6',
      desc: '',
      args: [],
    );
  }

  /// `Firts Name`
  String get simpleText7 {
    return Intl.message(
      'Firts Name',
      name: 'simpleText7',
      desc: '',
      args: [],
    );
  }

  /// `Missing last name`
  String get simpleText8 {
    return Intl.message(
      'Missing last name',
      name: 'simpleText8',
      desc: '',
      args: [],
    );
  }

  /// `Minimum 4 characters for LastName`
  String get simpleText9 {
    return Intl.message(
      'Minimum 4 characters for LastName',
      name: 'simpleText9',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get simpleText10 {
    return Intl.message(
      'Last Name',
      name: 'simpleText10',
      desc: '',
      args: [],
    );
  }

  /// `Please a Enter Username`
  String get simpleText11 {
    return Intl.message(
      'Please a Enter Username',
      name: 'simpleText11',
      desc: '',
      args: [],
    );
  }

  /// `Minimum 8 characters for UserName`
  String get simpleText12 {
    return Intl.message(
      'Minimum 8 characters for UserName',
      name: 'simpleText12',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get simpleText13 {
    return Intl.message(
      'Username',
      name: 'simpleText13',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get simpleText14 {
    return Intl.message(
      'Phone Number',
      name: 'simpleText14',
      desc: '',
      args: [],
    );
  }

  /// `Please a Enter Password`
  String get simpleText15 {
    return Intl.message(
      'Please a Enter Password',
      name: 'simpleText15',
      desc: '',
      args: [],
    );
  }

  /// `Minimum 12 characters for Password`
  String get simpleText16 {
    return Intl.message(
      'Minimum 12 characters for Password',
      name: 'simpleText16',
      desc: '',
      args: [],
    );
  }

  /// `At least 1 numbers and special characters`
  String get simpleText17 {
    return Intl.message(
      'At least 1 numbers and special characters',
      name: 'simpleText17',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get simpleText18 {
    return Intl.message(
      'Password',
      name: 'simpleText18',
      desc: '',
      args: [],
    );
  }

  /// `Please re-enter password`
  String get simpleText19 {
    return Intl.message(
      'Please re-enter password',
      name: 'simpleText19',
      desc: '',
      args: [],
    );
  }

  /// `Passwords don't match`
  String get simpleText20 {
    return Intl.message(
      'Passwords don\'t match',
      name: 'simpleText20',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get simpleText21 {
    return Intl.message(
      'Confirm Password',
      name: 'simpleText21',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get simpleText22 {
    return Intl.message(
      'Register',
      name: 'simpleText22',
      desc: '',
      args: [],
    );
  }

  /// `Have an account?`
  String get simpleText23 {
    return Intl.message(
      'Have an account?',
      name: 'simpleText23',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get simpleText24 {
    return Intl.message(
      'Sign In',
      name: 'simpleText24',
      desc: '',
      args: [],
    );
  }

  /// `Successful registration`
  String get simpleText25 {
    return Intl.message(
      'Successful registration',
      name: 'simpleText25',
      desc: '',
      args: [],
    );
  }

  /// `You can login now`
  String get simpleText26 {
    return Intl.message(
      'You can login now',
      name: 'simpleText26',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get simpleText27 {
    return Intl.message(
      'OK',
      name: 'simpleText27',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get simpleText28 {
    return Intl.message(
      'Try again',
      name: 'simpleText28',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get simpleText29 {
    return Intl.message(
      'Login',
      name: 'simpleText29',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get simpleText30 {
    return Intl.message(
      'Don\'t have an account?',
      name: 'simpleText30',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get simpleText31 {
    return Intl.message(
      'OK',
      name: 'simpleText31',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es', countryCode: 'MX'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}