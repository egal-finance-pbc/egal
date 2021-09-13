import 'package:conellas/common/deps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:international_phone_input/international_phone_input.dart';

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
                    margin: EdgeInsets.only(bottom: size.height * 0.44),
                    //height: 320,
                    decoration: BoxDecoration(
                        color: Color(0xff3B2F8F),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        )),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: size.height * 0.94),
                      child: Image.asset('assets/Logo.png',
                          height: size.height * 0.9,
                          alignment: Alignment.center),
                    ),
                  ),
                  SignUpForm(widget.deps),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.06),
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
                            Navigator.pushNamed(context, '/');
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.75),
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/phones');
                          },
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/scanners');
                          },
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

  TwilioPhoneVerify _twilioPhoneVerify;

  String phone;
  //final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isHidden = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _twilioPhoneVerify = TwilioPhoneVerify(
        accountSid: 'AC376189fed235dd2e7707b95f86b34c5a',
        serviceSid: 'VAb970c90d7a8937ee765360afebfe42f5',
        authToken: 'e30fa3d0b55d10c84832cfae1a2edc0d');
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phone = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    RegExp regMayus = RegExp(r'^(?=.*?[A-Z]).{1,}');
    RegExp regMinus = RegExp(r'^(?=.*?[a-z]).{1,}');
    RegExp regNum2 = RegExp(r'^(?=.*?[0-9]).{1,}$');
    RegExp regChar = RegExp(r'^(?=.*?[$&+,:;=?@#|])(?=.*?[<>.-^*()%!]).{1}');
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
                    margin: EdgeInsets.fromLTRB(30, size.height * 0.11, 30, 0),
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: InternationalPhoneInput(
                        enabledCountries: ['+91', '+1', '+52'],
                        errorText: 'no alphabetic and special characters',
                        errorMaxLines: 15,
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                              fontSize: 14.0, color: Color(0xffF8991C)),
                          errorBorder: OutlineInputBorder(
                            borderSide: new BorderSide(
                                color: Color(0xffF8991C), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Phone#',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          hintText: 'Phone#',
                          hintTextDirection: TextDirection.rtl,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        onPhoneNumberChange: onPhoneNumberChange,
                        initialPhoneNumber: phone,
                        initialSelection: 'MX',
                        showCountryCodes: true),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.21, 0, 0),
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: TextFormField(
                      controller: usernameController,
                      validator: (value) {
                        RegExp regMayus = RegExp(r'^(?=.*?[A-Z]).{1,}');
                        RegExp regMinus = RegExp(r'^(?=.*?[a-z]).{1,}');
                        RegExp regNum2 = RegExp(r'^(?=.*?[0-9]).{1,}$');
                        RegExp regUser = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,12}');
                        if (value.isEmpty) {
                          return 'Missing username';
                        } else if (!regMayus.hasMatch(value)) {
                          return 'at least 1 uppercase';
                        } else if (!regNum2.hasMatch(value)) {
                          return 'at least 1 number';
                        } else if (!regMinus.hasMatch(value)) {
                          return 'at least 1 lowercase';
                        } else if (!regUser.hasMatch(value)) {
                          return '6 characters minimum, 12 maximum';
                        } else if (value.length > 12) {
                          return 'Username length exceeded';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorStyle:
                            TextStyle(fontSize: 14.0, color: Color(0xffF8991C)),
                        errorBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color(0xffF8991C), width: 2),
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
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.32, 0, 0),
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                    child: TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        RegExp regPass = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,12}');
                        if (value.isEmpty) {
                          return 'Please a Enter Password';
                        } else if (!regMayus.hasMatch(value)) {
                          return 'at least 1 uppercase';
                        } else if (!regNum2.hasMatch(value)) {
                          return 'at least 1 number';
                        } else if (!regMinus.hasMatch(value)) {
                          return 'at least 1 lowercase';
                        } else if (!regChar.hasMatch(value)) {
                          return 'at least 1 special character';
                        } else if (!regPass.hasMatch(value)) {
                          return '6 characters minimum, 12 maximum';
                        } else if (value.length > 12) {
                          return 'Username length exceeded';
                        }
                        return null;
                      },
                      obscureText: _isHidden,
                      decoration: InputDecoration(
                        errorStyle:
                            TextStyle(fontSize: 14.0, color: Color(0xffF8991C)),
                        errorBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color(0xffF8991C), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Passcode',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                            color: Color(0xffF8991C),
                          ),
                        ),
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
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.43, 0, 0),
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
                        errorStyle:
                            TextStyle(fontSize: 14.0, color: Color(0xffF8991C)),
                        errorBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color(0xffF8991C), width: 2),
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
                          sendCode();
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

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void showSuccessDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var successDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.only(top: 60),
      titlePadding: const EdgeInsets.all(20),
      title: Text("Code sent, please check your messages"),
      content:
          Text("We have sent you a text message with the verification code"),
      actions: [
        Center(
          child: Container(
            width: size.width * 0.50,
            height: size.height * 0.06,
            child: FlatButton(
              color: Color(0xff3B2F8F),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              child: Text("OK"),
              onPressed: () {
                Navigator.pushNamed(context, '/verificationCode', arguments: {'phone' : phone, 'username' : usernameController.text, 'password' : passwordController.text});
              },
            ),
          ),
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
    Size size = MediaQuery.of(context).size;
    var errorDialog = AlertDialog(
      title: err.title(),
      content: err.content(),
      actions: [
        Center(
          child: Container(
            width: size.width * 0.50,
            height: size.height * 0.06,
            child: FlatButton(
              color: Color(0xff3B2F8F),
              child: Text("Try again"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
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

  void sendCode() async {
    if(phone.isEmpty) return;
    TwilioResponse twilioResponse = await _twilioPhoneVerify.sendSmsCode(phone);
    if(twilioResponse.successful) {
      print('Code sent to ${phone}');
      await Future.delayed(Duration(seconds: 1));
      showSuccessDialog(context);
    }
  }
}
