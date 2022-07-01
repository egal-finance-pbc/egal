import 'package:conellas/common/deps.dart';
import 'package:conellas/common/dialog.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../clients/api.dart';

class SignInPage extends StatefulWidget {
  final Dependencies deps;

  SignInPage(this.deps, {Key key}) : super(key: key);

  @override
  _SignInPageState createState() {
    return new _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF8991C),
      appBar: AppBar(
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
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: size.height * 0.88),
                      child: Image.asset('assets/Logo.png',
                          height: size.height * 0.9,
                          alignment: Alignment.center),
                    ),
                  ),
                  LoginForm(widget.deps),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.15),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        FlatButton(
                          textColor: Color(0xffF8991C),
                          child:
                              Text('Sign up', style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 2.0,
                          width: size.width * 0.3,
                          color: Colors.white,
                        ),
                        Text(
                          'Contact Egal',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 2.0,
                          width: size.width * 0.3,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.74),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () async {
                            const _url = 'https://egal.app';
                            await canLaunch(_url)
                                ? await launch(_url)
                                : throw 'Could not launch $_url';
                          },
                          child: Icon(
                            Icons.web,
                            color: Colors.white,
                            size: 25,
                          ),
                          color: Color(0xff3B2F8F),
                          shape: CircleBorder(),
                          height: 50,
                        ),
                        FlatButton(
                          onPressed: () {},
                          child: Icon(
                            Icons.facebook,
                            color: Colors.white,
                            size: 25,
                          ),
                          color: Color(0xff3B2F8F),
                          shape: CircleBorder(),
                          height: 50,
                        ),
                        FlatButton(
                          onPressed: () {
                            //SessionParams.deleteSession();
                          },
                          child: Icon(
                            Icons.chat_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                          color: Color(0xff3B2F8F),
                          shape: CircleBorder(),
                          height: 50,
                        ),
                        FlatButton(
                          onPressed: () {},
                          child: Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                            size: 25,
                          ),
                          color: Color(0xff3B2F8F),
                          shape: CircleBorder(),
                          height: 50,
                        ),
                      ],
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
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = Center(
    child: FlatButton(
      color: Color(0xff3B2F8F),
      child: Text(
        "OK",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Invitation QR",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    content: Image.asset('assets/PruebaApp1.png'),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    actions: [
      okButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class LoginForm extends StatefulWidget {
  final Dependencies deps;

  LoginForm(this.deps, {Key key}) : super(key: key);

  @override
  _LoginFormState createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    loadData();
    FingerprintAPI.loginWithBiometrics(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.22, 0, 0),
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: TextFormField(
                      controller: this.usernameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Missing username';
                        } else if (value.length > 150) {
                          return 'Username length exceeded';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Username',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        hintText: 'Username',
                        hintTextDirection: TextDirection.rtl,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.33, 0, 0),
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: TextFormField(
                      controller: this.passwordController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Missing password';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Passcode',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        hintText: 'passcode',
                        hintTextDirection: TextDirection.rtl,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(
                            0, size.height * 0.43, 0, size.height * 0.43),
                        padding: EdgeInsets.fromLTRB(30, 0, 5, 0),
                        child: Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                            activeColor: Color(0xffF8991C),
                            checkColor: Colors.white,
                            value: isChecked,
                            onChanged: rememberme,
                          ),
                        ),
                      ),
                      Text(
                        'Remember',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.59, 0, 0),
                    padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                    width: double.infinity,
                    height: size.height * 0.06,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff3B2F8F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        try {
                          ProgressDialog progressDialog =
                              ProgressDialog(context);
                          progressDialog.show();
                          var token = await widget.deps.api.login(
                              this.usernameController.text,
                              this.passwordController.text,
                              context);
                          var sessionStorage = widget.deps.session;
                          await sessionStorage.set('token', token.token);

                          var me = await widget.deps.api.me();
                          await sessionStorage.set('publicKey', me.publicKey);
                          await sessionStorage.set('savingKey', me.savingKey);
                          rememberme(isChecked);
                        } catch (err) {
                          await FlutterSession().set('token', '');
                          ProgressDialog progressDialog =
                              ProgressDialog(context);
                          progressDialog.dismiss();
                          showErrorDialog(context, err);
                        }
                      },
                      child: Text(
                        'Sign In',
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

  void showErrorDialog(BuildContext context, err) {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: err.title(),
      text: err.content(),
      confirmBtnColor: Color(0xff3B2F8F),
      backgroundColor: Color(0xffF8991C),
    );
  }

  void rememberme(bool value) {
    isChecked = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('remember_me', value);
      prefs.setString('user', usernameController.text);
      prefs.setString('passcode', passwordController.text);
    });
    setState(() {
      isChecked = value;
    });
  }

  void loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString('user') ?? '';
      var passcode = prefs.getString('passcode') ?? '';
      var remember_me = prefs.getBool('remember_me') ?? false;
      print(remember_me);
      print(user);
      print(passcode);
      if (remember_me) {
        setState(() {
          isChecked = true;
        });
        usernameController.text = user ?? '';
        //passwordController.text = passcode ?? '';
      }
    } catch (e) {
      print(e);
    }
  }
}
