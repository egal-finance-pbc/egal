import 'package:conellas/instructionsPage/LoadScreen.dart';
import 'package:conellas/pages/QRscan.dart';
import 'package:flutter/material.dart';

import 'common/deps.dart';
import 'instructionsPage/faceID.dart';
import 'instructionsPage/fingerprint.dart';
import 'instructionsPage/takePicture.dart';
import 'instructionsPage/verificationCode.dart';
import 'pages/home.dart';
import 'pages/search.dart';
import 'pages/send.dart';
import 'pages/signin.dart';
import 'pages/signup.dart';
import 'pages/receive.dart';
import 'pages/profile.dart';
import 'pages/profileEdit.dart';
import 'pages/navigatorBar.dart';

void main() {
  runApp(ConEllasApp());
}

class ConEllasApp extends StatelessWidget {
  final Dependencies deps = Dependencies();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Con Ellas',


      initialRoute: '/',
      routes: {
        '/': (context) => SignInPage(deps),
        '/signup': (context) => SignUpPage(deps),
        '/home': (context) => HomePage(deps),
        '/search': (context) => SearchPage(deps),
        '/send': (context) => SendPage(deps),
        '/navigatorBar': (context) => BottomNavBar(deps),
        '/scanners': (context) => QRViewExample(),
        '/photos': (context) => Photos(),
        '/fingers': (context) => fingerAuto(),
        '/faces': (context) => faceIdAuto(),
        '/profileView': (context) => profileView(deps),
        '/profileEdit': (context) => profileEdit(deps),
        '/verificationCode': (context) => verificationCode(deps),
        '/loader': (context) => Loader(),
        '/receive': (context) => ReceivePage(deps),






      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


  
