import 'package:conellas/common/deps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:conellas/generated/l10n.dart';
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
        title: Text(S.of(context).simpleText, style: new TextStyle(fontFamily: 'ComfortaaBold', fontSize: 18,),),
        backgroundColor: Color(0xff330199),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                width: double.maxFinite,
              alignment: Alignment.center,
                height: 100,
              child: Image.asset('assets/img/egalLogo.png',
                fit: BoxFit.cover,
              )
            ),
            Container(
              margin: const EdgeInsets.only(top: 60),
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child:ListView(
                children: [
                  SignUpForm(widget.deps),
                ],
              )



                  ),
              ]
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
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              controller: firstNameController,
              textCapitalization: TextCapitalization.words,
              maxLength: 24,
              validator: (value) {
                if (value.isEmpty) {
                  return S.of(context).simpleText3;
                } else if (!regname.hasMatch(value)) {
                  return S.of( context).simpleText4;
                } else if (regchar.hasMatch(value) || regnum.hasMatch(value)) {
                  return S.of(context).simpleText5;
                }else if (!regMayus.hasMatch(value)) {
                  return S.of(context).simpleText6;
                }
                return null;
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                enabledBorder : OutlineInputBorder(
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
                labelText: S.of(context).simpleText7,
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
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              controller: lastNameController,
              textCapitalization: TextCapitalization.words,
              maxLength: 24,
              validator: (value) {
                if (value.isEmpty) {
                  return S.of(context).simpleText8;
                } else if (!regname.hasMatch(value)) {
                  return S.of(context).simpleText9;
                } else if (regchar.hasMatch(value) || regnum.hasMatch(value)) {
                  return S.of(context).simpleText5;
                }else if (!regMayus.hasMatch(value)) {
                  return S.of(context).simpleText6;
                }
                return null;
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                enabledBorder : OutlineInputBorder(
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
                labelText: S.of(context).simpleText10,
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
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: usernameController,
              maxLength: 12,
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
                enabledBorder : OutlineInputBorder(
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
              padding: EdgeInsets.all(10),
              child: IntlPhoneField(
                decoration: InputDecoration(
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
                  labelText: S.of(context).simpleText14,
                  labelStyle: TextStyle(
                    fontFamily: 'Comfortaaregular',
                    fontSize: 20,
                    color: Color(0xffFF9900),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: const EdgeInsets.all(15),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  print(phone.completeNumber);
                  print(phone.countryCode);
                  print(phone.number);
                },
              )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              maxLength: 12,
              validator: (String value) {
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
              obscureText: false,
              decoration: InputDecoration(
                fillColor: Colors.white,
                enabledBorder : OutlineInputBorder(
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
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              controller: confirmPasswordController,
              keyboardType: TextInputType.text,
              validator: (String value) {
                if (value.isEmpty) {
                  return S.of(context).simpleText19;
                }
                if (passwordController.text != confirmPasswordController.text) {
                  return S.of(context).simpleText20;
                }
                return null;
              },
              obscureText: true,
              decoration: InputDecoration(
                fillColor: Colors.white,
                enabledBorder : OutlineInputBorder(
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
                labelText: S.of(context).simpleText21,
                labelStyle: TextStyle(
                  fontFamily: 'Comfortaaregular',
                  fontSize: 20,
                  color: Color(0xffFF9900),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.all(12),
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
              child: Text(S.of(context).simpleText22, style: TextStyle(fontFamily: 'ComfortaaBold', fontSize: 16),),
              style: ElevatedButton.styleFrom(
                primary: Color(0xffFF9900),
              ),
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Text(S.of(context).simpleText23, style: TextStyle(fontFamily: 'ComfortaaRegular', )),
                FlatButton(
                  textColor: Colors.blue,
                  child: Text(S.of(context).simpleText24, style: TextStyle(fontSize: 16, fontFamily: 'ComfortaaBold',)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    var successDialog = AlertDialog(
      title: Text(S.of(context).simpleText25),
      content: Text(S.of(context).simpleText26),
      actions: [
        FlatButton(
          child: Text(S.of(context).simpleText27),
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
          child: Text(S.of(context).simpleText28 ),
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
