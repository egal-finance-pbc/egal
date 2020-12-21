import 'package:flutter/material.dart';
import '../widgets/slide_item.dart';
import '../model/slide.dart';
import '../widgets/slide_dots.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

class GettingStartedScreen extends StatefulWidget {
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: slideList.length,
                      itemBuilder: (ctx, i) => SlideItem(i),
                    ),
                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 50),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              for(int i = 0; i<slideList.length; i++)
                                if( i == _currentPage )
                                  SlideDots(true)
                                else
                                  SlideDots(false)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      'REGISTRO',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                     shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.5),),
                      onPressed: ()  {
                      Navigator.of(context).pushNamed(SignupScreen.routeName);
                    },
                      color: Color(0xFF7F3F98),
                      textColor: Color(0xFFD89555),
                  ),
                  RaisedButton(
                    child: Text(
                      'INGRESO',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.5),),
                      onPressed: () {
                          Navigator.of(context).pushNamed(LoginScreen.routeName);
                        },
                      color: Color(0xFF7F3F98),
                      textColor: Color(0xFFD89555),
                  ),
                   SizedBox(
                height: 15,
              ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 48,
          color: Color(0xFFF4A522)
        ),
      ),
    );
  }
}
