import 'package:conellas/common/deps.dart';
import 'package:conellas/instructionsPage/takePicture.dart';
import 'package:conellas/pages/home.dart';
import 'package:conellas/pages/profile.dart';
import 'package:conellas/pages/receive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-item.dart';
import 'package:conellas/clients/api.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'QRscan.dart';

class BottomNavBar extends StatefulWidget {
  final Dependencies deps;

  const BottomNavBar(this.deps, {Key key}) : super(key: key);

  @override
  _BottomNavBarState createState() {
    return new _BottomNavBarState();
  }
}

class _BottomNavBarState extends State<BottomNavBar>  with TickerProviderStateMixin  {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: "Send",
        useSafeArea: true, // default: true, apply safe area wrapper
        labels: const ["Send", "Receive", "Profile"],
        icons: const [Icons.call_made, Icons.call_received, Icons.people_alt],

        // optional badges, length must be same with labels
        badges: [
          // Default Motion Badge Widget
          const MotionBadgeWidget(
            text: '',
            textColor: Colors.white, // optional, default to Colors.white
            size: 18, // optional, default to 18
          ),

          // custom badge Widget
          Container(
            padding: const EdgeInsets.all(2),
            child: const Text(
              '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),

          // allow null


          // Default Motion Badge Widget with indicator only
          const MotionBadgeWidget(
 // true / false
          ),
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        tabIconColor: Colors.white,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Color(0xffF8991C),
        tabIconSelectedColor: Colors.white,
        tabBarColor: const Color(0xff3B2F8F),
        onTabItemSelected: (int value) {
          setState(() {
            _tabController?.index = value;
          });
        },
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
        controller: _tabController,
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          HomePage(widget.deps),
          ReceivePage(widget.deps),
          ProfileView(widget.deps),
        ],
      ),
    );
  }
}

/*
        Container(
          color: Colors.blueAccent,
          child: Center(
            child: Column(
              children: <Widget>[
                Text(_page.toString(), textScaleFactor: 10.0),
                ElevatedButton(
                  child: Text('Go To Page of index 1'),
                  onPressed: () {
                    //Page change using state does the same as clicking index 1 navigation button
                    final CurvedNavigationBarState navBarState =
                        _bottomNavigationKey.currentState;
                    navBarState?.setPage(1);
                  },
                )
              ],
            ),
          ),
        )
                 */
