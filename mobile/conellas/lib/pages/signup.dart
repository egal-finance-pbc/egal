import 'package:conellas/common/deps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../clients/api.dart';

class SignUpPage extends StatefulWidget {
  final Dependencies deps;

  SignUpPage(this.deps, {Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => new _SignUpPageState(deps);
}

class _SignUpPageState extends State<SignUpPage> {
  _SignUpPageState(Dependencies deps);

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
                    margin: EdgeInsets.only(bottom: size.height * 0.45),
                    //height: 320,
                    decoration: BoxDecoration(
                        color: Color(0xff3B2F8F),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        )),
                  ),
                  SignUpForm(widget.deps),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Already an user?',
                          style: TextStyle(color: Colors.white),
                        ),
                        FlatButton(
                          textColor: Color(0xffF8991C),
                          child:
                              Text('Sign In', style: TextStyle(fontSize: 16)),
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height *  0.75),
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
                          'Contac Egal',
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
                    margin: EdgeInsets.only(top: size.height * 0.79),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () async {
                            const _url = 'https://egal.app';
                            await canLaunch(_url)
                                ? await launch(_url)
                                : throw 'Could not launch $_url';
                          },
                          child: Icon(
                            IconData(59101, fontFamily: 'MaterialIcons'),
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
                            IconData(63281, fontFamily: 'MaterialIcons'),
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
                            IconData(57683, fontFamily: 'MaterialIcons'),
                            color: Colors.white,
                            size: 25,
                          ),
                          color: Color(0xff3B2F8F),
                          shape: CircleBorder(),
                          height: 50,
                        ),
                        FlatButton(
                          onPressed: () {
                            showAlertDialog(context);
                          },
                          child: Icon(
                            IconData(58615, fontFamily: 'MaterialIcons'),
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
                    margin: EdgeInsets.fromLTRB(0, size.height*0.05, 0, 0),
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
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
                        helperStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Firts name',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        hintText: 'Firts name',
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
                    margin: EdgeInsets.fromLTRB(0, size.height*0.14, 0, 0),
                    padding: EdgeInsets.fromLTRB(30, 10, 30,  0),
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
                        helperStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Last name',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        hintText: 'Last name',
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
                    margin: EdgeInsets.fromLTRB(0, size.height*0.24, 0, 0),
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
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
                        helperStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
                    margin: EdgeInsets.fromLTRB(0, size.height*0.34, 0, 0),
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
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
                        helperStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Passcode',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        hintText: 'Passcode',
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
                    margin: EdgeInsets.fromLTRB(0, size.height*0.44, 0, 0),
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: TextFormField(
                        controller: confirmPasswordController,
                      keyboardType: TextInputType.text,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please re-enter password';
                        }
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          return "Passwords don't match";
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        helperStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Confirm Passcode',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        hintText: 'Confirm Passcode',
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
                    margin: EdgeInsets.only(top: size.height * 0.63),
                    padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                    width: double.infinity,
                    height: 70,
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
                      child: Text(
                        'Sign Up',
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
    var errorDialog = AlertDialog(
      title: err.title(),
      content: err.content(),
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
