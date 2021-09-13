import 'package:conellas/common/deps.dart';
import 'package:conellas/common/dialog.dart';
import 'package:conellas/instructionsPage/takePicture.dart';
import 'package:conellas/pages/home.dart';
import 'package:conellas/pages/profile.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:conellas/clients/api.dart';
import 'package:flutter/services.dart';

import 'QRscan.dart';

class BottomNavBar extends StatefulWidget {
  final Dependencies deps;

  const BottomNavBar(this.deps, {Key key}) : super(key: key);

  @override
  _BottomNavBarState createState() {
    return new _BottomNavBarState();
  }
}

class _BottomNavBarState extends State<BottomNavBar> {
  // Custom navigator takes a global key if you want to access the
  // navigator from outside it's widget tree subtree
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      scaffold: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), title: Text('home')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.event), title: Text('events')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.save_alt), title: Text('downloads')),
            ],
            backgroundColor: Color(0xff3B2F8F),
            selectedItemColor: Color(0xffF8991C),
            unselectedItemColor: Colors.white,
          ),
        ),
      children: <Widget>[
        HomePage(widget.deps),
        HomePage(widget.deps),
        profileView(widget.deps),
      ],
    );
  }
}
