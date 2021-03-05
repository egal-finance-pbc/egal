import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import '../clients/api.dart';

class SignInPage extends StatefulWidget {
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
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'ConEllas',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
            ),
            LoginForm(),
            Container(
              child: Row(
                children: <Widget>[
                  Text('Don\'t have an account?'),
                  FlatButton(
                    textColor: Colors.blue,
                    child: Text('Sign up', style: TextStyle(fontSize: 16)),
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
                  return 'Missing username';
                } else if (value.length > 150) {
                  return 'Username length exceeded';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
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
                  return 'Missing password';
                }
                return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
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
                  var api = API();
                  var token = await api.login(
                    this.usernameController.text,
                    this.passwordController.text,
                  );
                  var sessionStorage = FlutterSession();
                  await sessionStorage.set('token', token.token);

                  var accountId = await api.me();
                  await sessionStorage.set('publicKey', accountId.publicKey);

                  Navigator.pushNamed(context, '/home');
                } catch (err) {
                  await FlutterSession().set('token', '');
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Invalid credentials"),
                        content: Text(err.toString()),
                        actions: [
                          FlatButton(
                            child: Text("Try again"),
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
              child: Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
