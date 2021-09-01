import 'package:flutter/material.dart';

class fingerAuto extends StatefulWidget {
  const fingerAuto({Key key}) : super(key: key);

  @override
  _fingerAutoState createState() => _fingerAutoState();
}

class _fingerAutoState extends State<fingerAuto> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () => showAlert(context));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF8991C),
      appBar: AppBar(
        title: Text('fingerprint authenticator'),
        backgroundColor: Color(0xff3B2F8F),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(

          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: size.height * 0.53,
                    //height: 320,
                    decoration: BoxDecoration(
                        color: Color(0xff3B2F8F),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, size.height*0.08, 0, 0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: size.height*0.30,
                        width: size.height*0.30,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Color(0xffF8991C),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child:ClipOval(
                          child: Icon(Icons.fingerprint, size: size.height*0.25, color: Colors.white,),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, size.height*0.68, 0, 0),
                    padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                    width: double.infinity,
                    height: size.height * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff3B2F8F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      onPressed: (){

                      },
                      child: Text(
                        'Authenticate',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showAlert(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        actionsPadding: const EdgeInsets.only(top: 60),
        titlePadding: const EdgeInsets.all(20),
        title: Text('fingerprint authenticator'),
        content:
        Text('We need to verify if you have a fingerprint on your device'),
        actions: [
          Center(
            child: Container(
              width: size.width * 0.50,
              height: size.height * 0.06,
              child: FlatButton(
                color: Color(0xff3B2F8F),
                child: Text("OK"),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

