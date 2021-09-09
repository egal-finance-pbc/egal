import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(const Loader());

class Loader extends StatelessWidget {
  const Loader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            // Load a Lottie file from your assets
            Lottie.asset('assets/lottie/egalsplash.json',  height: size.height * 0.90,
              fit: BoxFit.fill,),
          ],
        ),
      ),
    );
  }
}