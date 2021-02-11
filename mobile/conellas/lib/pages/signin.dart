import 'package:flutter/material.dart';
import 'package:conellas/pages/BalancePage.dart';

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
        padding: EdgeInsets.all(20),
        child: ListView(children: <Widget>[
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
        ]),
      ),
    );

  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: TextFormField(
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
                )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: TextFormField(
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
                onPressed: () {

                  if (_formKey.currentState.validate()) {
                    Navigator.of(context)
                        .push(
                        MaterialPageRoute(
                            builder: (context)=> BalancePage()
                        )
                    );
                  }
                },
                child: Text('Login'),
              ),
            ),
          ],
        )
    );
  }
}









/*
Container(
padding: EdgeInsets.all(10),
child: TextFormField(
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
child: ElevatedButton(
//textColor: Colors.white,
//color: Colors.blue,
child: Text('Login'),
onPressed: () {
if(vaule == null){
Text ('Please enter some text');
}else{
Navigator.of(context)
    .push(
MaterialPageRoute(
builder: (context)=> BalancePage()
)
);
}

},

),
),
 */
