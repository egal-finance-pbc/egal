import 'package:conellas/common/deps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:conellas/generated/l10n.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).simpleText2,
            style: new TextStyle(
              fontFamily: 'ComfortaaBold',
              fontSize: 18,
            )),
        backgroundColor: Color(0xff330199),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  'assets/img/egalLogo.png',
                  fit: BoxFit.cover,
                  height: 150,
                )),
            LoginForm(widget.deps),
            Container(
              child: Row(
                children: <Widget>[
                  Text(S.of(context).simpleText30, style: TextStyle(fontFamily: 'ComfortaaRegular')),
                  FlatButton(
                    textColor: Colors.blue,
                    child: Text(S.of(context).simpleText, style: TextStyle(fontSize: 16, fontFamily: 'ComfortaaBold')),
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
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
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    RegExp regname = RegExp(r'^(?=.*?[a-z]).{4,24}$');
    RegExp reguser = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z]).{8,12}$');
    RegExp regnum = RegExp(r'^(?=.*?[0-9]).{2,24|}$');
    RegExp regchar = RegExp(r'^(?=.*?[!@#\$&*~]).{2,24}$');
    RegExp regMayus = RegExp(r'^(?=.*?[A-Z]).{2,}$');
    RegExp regpass = RegExp(r'^(?=.*?[a-z]).{12,}$');
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: TextFormField(
              controller: this.usernameController,
              validator: (value) {
                if (value.isEmpty) {
                  return S.of(context).simpleText11;
                }else if(!reguser.hasMatch(value)){
                  return S.of(context).simpleText12;
                }
                return null;
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xff330199),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xffFF9900),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                labelText: S.of(context).simpleText13,
                labelStyle: TextStyle(
                  fontFamily: 'Comfortaaregular',
                  fontSize: 20,
                  color: Color(0xffFF9900),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: TextFormField(
              controller: this.passwordController,
              validator: (value) {
                if (value.isEmpty) {
                  return S.of(context).simpleText15;
                }else if(!regpass.hasMatch(value)){
                  return S.of(context).simpleText16;
                }else if(!regnum.hasMatch(value) && !regchar.hasMatch(value)){
                  return S.of(context).simpleText17;
                }else if(!regMayus.hasMatch(value)) {
                  return S.of(context).simpleText6;
                }
                return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xff330199),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xffFF9900),
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                labelText: S.of(context).simpleText18,
                labelStyle: TextStyle(
                  fontFamily: 'Comfortaaregular',
                  fontSize: 20,
                  color: Color(0xffFF9900),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                try {
                  var token = await widget.deps.api.login(
                    this.usernameController.text,
                    this.passwordController.text,
                  );
                  var sessionStorage = widget.deps.session;
                  await sessionStorage.set('token', token.token);

                  var me = await widget.deps.api.me();
                  await sessionStorage.set('publicKey', me.publicKey);

                  Navigator.pushNamed(context, '/home');
                } catch (err) {
                  await FlutterSession().set('token', '');
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: err.title(),
                        content: err.content(),
                        actions: [
                          FlatButton(
                            child: Text(S.of(context).simpleText28),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                    barrierDismissible: false,
                  );
                }
              },
              child: Text(S.of(context).simpleText29,
                style: TextStyle(fontFamily: 'ComfortaaBold', fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xffFF9900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
