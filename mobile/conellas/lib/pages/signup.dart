import 'package:conellas/common/deps.dart';
import 'package:flutter/material.dart';
import '../clients/api.dart';

class SignUpPage extends StatefulWidget {
  final Dependencies deps;

  SignUpPage(this.deps, {Key key}) : super(key: key);

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
                  fontSize: 30,
                ),
              ),
            ),
            SignUpForm(widget.deps),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final Dependencies deps;

  SignUpForm(this.deps, {Key key}) : super(key: key);

  @override
  _SignUpFormState createState() {
    return _SignUpFormState();
  }
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
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
              validator: (value) {
                if (value.isEmpty) {
                  return 'Missing first name';
                } else if (value.length > 150) {
                  return 'First name length exceeded';
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
              validator: (value) {
                if (value.isEmpty) {
                  return 'Missing last name';
                } else if (value.length > 150) {
                  return 'Last name length exceeded';
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
              validator: (value) {
                if (value.isEmpty) {
                  return 'Missing username';
                } else if (value.length > 150) {
                  return 'Username length exceeded';
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
              validator: (String value) {
                if (value.isEmpty) {
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
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please re-enter password';
                }
                if (passwordController.text != confirmPasswordController.text) {
                  return "Passwords don't match";
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
                if (!_formKey.currentState.validate()) {
                  return;
                }
                try {
                  await widget.deps.api.signup(
                    this.firstNameController.text,
                    this.lastNameController.text,
                    this.usernameController.text,
                    this.passwordController.text,
                  );
                  showSuccessDialog(context);
                } catch (err) {
                  showErrorDialog(context, err);
                }
              },
              child: Text('Register'),
            ),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    var successDialog = AlertDialog(
      title: Text("Successful registration"),
      content: Text("You can login now"),
      actions: [
        FlatButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext _) {
        return successDialog;
      },
    );
  }

  void showErrorDialog(BuildContext context, err) {
    var errorAPI = APIError();
    var errorDialog = AlertDialog(
      title: Text(errorAPI.title(response)),
      content: Text(errorAPI.content(response)),
      actions: [
        FlatButton(
          child: Text("Try again"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext _) {
        return errorDialog;
      },
    );
  }
}
