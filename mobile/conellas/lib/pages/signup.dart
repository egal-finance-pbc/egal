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
                  fontSize: 30
                ),
              ),
            ),
            SignInForm(),
          ],
        ),
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  SignInFormState createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

   //TextController to read text entered in text field
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                validator: (value){
                  if(value.isEmpty){
                    return 'Missing first name';
                  }else if(value.length > 150){
                    return 'Firts name length exceded';
                  }
                  return null;
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
                validator: (value){
                  if(value.isEmpty){
                    return 'Missing last name';
                  }else if(value.length > 150){
                    return 'Last name length exceded';
                  }
                  return null;
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
                validator: (value){
                  if(value.isEmpty){
                    return 'Missing username';
                  }else if(value.length > 150){
                    return 'Username length exceded';
                  }
                  return null;
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
                controller: password,
                keyboardType: TextInputType.text,
                validator: (String value){
                  if(value.isEmpty){
                    return 'Please a Enter Password';
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
              child: TextFormField(
                controller: confirmpassword,
                 keyboardType: TextInputType.text,
                validator: (String value){
                  if(value.isEmpty){
                    return 'Please re-enter password';
                  }
                  print(password.text);

                  print(confirmpassword.text);
                  
                  if(password.text!=confirmpassword.text){
                    return "Password does not match";
                  }
                  return null;
                },
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
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {

                if (_formKey.currentState.validate()) {
                  Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Sending your information')));
                }
              },
              child: Text('Register'),
            ),
          ),
        ],
      )
    );
  }
}