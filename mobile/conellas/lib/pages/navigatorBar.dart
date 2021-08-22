import 'package:conellas/common/deps.dart';
import 'package:conellas/pages/home.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:conellas/clients/api.dart';
import 'package:flutter/services.dart';

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
    List<Widget> _children() =>
        [
          HomePage(widget.deps),
          Text('2'),
          Text('3'),
          Text('4'),
        ];
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 60.0,
          items: <Widget>[
            Icon(Icons.call_made, size: 30, color: Colors.white,),
            Icon(Icons.call_received, size: 30, color: Colors.white),
            Icon(Icons.supervised_user_circle, size: 30, color: Colors.white),
          ],
          color: Color(0xff3B2F8F),
          buttonBackgroundColor: Color(0xff3B2F8F),
          backgroundColor: Color(0xffF8991C),
          animationCurve: Curves.easeOutCirc ,
          animationDuration: Duration(milliseconds: 500),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: _children()[_page],
    );
  }
}