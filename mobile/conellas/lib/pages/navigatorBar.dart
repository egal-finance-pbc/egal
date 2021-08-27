import 'package:conellas/common/deps.dart';
import 'package:conellas/pages/home.dart';
import 'package:conellas/pages/search.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<Widget> _children() => [
          HomePage(widget.deps),
          SearchPage(widget.deps),
        ];
    return  CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Color(0xff3B2F8F),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.call_made,
                size: 30,
                color: Colors.white,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.call_received, size: 30, color: Colors.white),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle,
                  size: 30, color: Colors.white),
            )
          ],
        ),
        tabBuilder: (context, index) {
          switch(index){
            case 0:
              return CupertinoTabView(builder: (context){
                return CupertinoPageScaffold(
                  child: HomePage(widget.deps),
                );
              });
            case 1:
              return CupertinoTabView(builder: (context){
                return CupertinoPageScaffold(
                  child: Text('hola'),
                );
              });

            default:
              return CupertinoTabView(builder: (context){
                return CupertinoPageScaffold(
                  child: HomePage(widget.deps),
                );
              });
          }
        }
    );
  }
}
