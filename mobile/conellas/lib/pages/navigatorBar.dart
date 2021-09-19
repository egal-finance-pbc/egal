import 'package:conellas/common/deps.dart';
import 'package:conellas/instructionsPage/takePicture.dart';
import 'package:conellas/pages/home.dart';
import 'package:conellas/pages/profile.dart';
import 'package:conellas/pages/receive.dart';
import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
                  icon: Icon(Icons.call_made), title: Text('Send')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.call_received), title: Text('Recived')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.face), title: Text('Profile')),
            ],
            backgroundColor: Color(0xff3B2F8F),
            selectedItemColor: Color(0xffF8991C),
            unselectedItemColor: Colors.white,
          selectedFontSize:16.0,
          showUnselectedLabels: false,
          ),
        ),
      children: <Widget>[
        HomePage(widget.deps),
        ReceivePage(widget.deps),
        profileView(widget.deps),
      ],
    );
  }
}
