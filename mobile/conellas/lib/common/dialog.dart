import 'package:conellas/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'deps.dart';

class ProgressDialog {
  final BuildContext context;
  final Dependencies deps = Dependencies();

  ProgressDialog(this.context);

  void show() {
    Size size = MediaQuery
        .of(context)
        .size;
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    HeartbeatProgressIndicator(
                      child: Container(
                        height: size.height * 0.10,
                        width: size.height * 0.10,
                        child: Image.asset(
                          'assets/icon.png',
                        ),
                      ),
                    ),

                    /*
              Container(
                margin: EdgeInsets.all(size.height * 0.01),
                height: size.height * 0.20,
                width: size.height * 0.20,
                child: Image.asset(
                  'assets/icon.png',
                ),
              ),
              TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 4),
                builder: (context, value, _) => SizedBox(
                  height: size.height * 0.22,
                  width: size.height * 0.22 ,
                  child: CircularProgressIndicator(
                    color: Color(0xff3B2F8F),
                    backgroundColor: Colors.orange,
                    strokeWidth: 5,
                  ),

                ),

              ),
               */
                  ],
                ),
              ],
            ),
          );
        });
  }

  void dismiss() {
    Navigator.of(context).pop();
  }

  void dismissHome() {
  Navigator.of(context, rootNavigator: true).pop();
  }
}
