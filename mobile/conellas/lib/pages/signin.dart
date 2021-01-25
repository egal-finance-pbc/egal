import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
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
                  fontSize: 30),
                ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.blue,
                child: Text('Login'),
                onPressed: () {},
              ),
            ),
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
