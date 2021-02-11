import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                  fontSize: 30
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                validator: (String value){
                  if(value.trim().length > 150){
                    return null;
                  }
                  return 'Missing first name';
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                validator: (String value){
                  if(value.trim().length > 150){
                    return null;
                  }
                  return 'Missing last name';
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                validator: (String value){
                  if(value.trim().length > 150){
                    return null;
                  }
                  return 'Missing username';
                },
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
              child: TextFormField(
                validator: (value){
                  if(value.isEmpty){
                    return 'Missing password';
                  }
                  return null;
                },
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
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
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
                child: Text('Register'),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
