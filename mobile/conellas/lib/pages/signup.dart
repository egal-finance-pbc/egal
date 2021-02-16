import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

import '../clients/api.dart';


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
  _SignInFormState createState() {
    return _SignInFormState();
  }
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

   //TextController to read text entered in text field
  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                controller: firstNameController,
                validator: (value){
                  if (value.isEmpty){
                    return 'Missing first name';
                  } else if(value.length > 150){
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
                controller: lastNameController,
                validator: (value){
                  if (value.isEmpty){
                    return 'Missing last name';
                  } else if(value.length > 150){
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
                controller: usernameController,
                validator: (value){
                  if (value.isEmpty){
                    return 'Missing username';
                  } else if(value.length > 150){
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
                controller: passwordController,
                keyboardType: TextInputType.text,
                validator: (String value){
                  if (value.isEmpty){
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
                controller: confirmPasswordController,
                 keyboardType: TextInputType.text,
                validator: (String value){
                  if (value.isEmpty){
                    return 'Please re-enter password';
                  }
                  
                  if (passwordController.text!=confirmPasswordController.text){
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
             padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  registrationAlert(context);
                  var api = API();
                  var account = await api.signUp(
                    this.firstNameController.text,
                    this.lastNameController.text,
                    this.usernameController.text,
                    this.passwordController.text,
                  );
                }
                try {
                  var api = API();
                  var account = await api.signUp(
                    this.firstNameController.text,
                    this.lastNameController.text,
                    this.usernameController.text,
                    this.passwordController.text,
                  );
                } catch(err) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Registration failed"),
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
              child: Text('Register'),
            ),
          ),
        ],
      )
    );
  }
void registrationAlert(BuildContext context){
    var alertDialog = AlertDialog(
      title: Text("Successful registration"),
      content: Text("Please verify your email"),
      actions: [
        FlatButton(
          child: Text('Close'),
          onPressed: (){
            Navigator.pushNamed(context, '/');
          },
        ),
      ],
    );
}
}
