import 'package:conellas/common/deps.dart';
import 'package:conellas/common/dialog.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:url_launcher/url_launcher.dart';

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
                    height: size.height * 0.70,
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
                    margin: EdgeInsets.only(top: size.height * 0.12),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Already a user?',
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
                    margin: EdgeInsets.only(top: size.height * 0.76),
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
                          'Contact Egal',
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
                    margin: EdgeInsets.only(top: size.height * 0.80),
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
                            Icons.web,
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
                            Icons.facebook,
                            color: Colors.white,
                            size: 25,
                          ),
                          color: Color(0xff3B2F8F),
                          shape: CircleBorder(),
                          height: 50,
                        ),
                        FlatButton(
                          onPressed: () {
                            //SessionParams.deleteSession();
                          },
                          child: Icon(
                            Icons.chat_rounded,
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
                            Icons.qr_code_scanner,
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
  FocusNode _focusNode = new FocusNode();

  TwilioPhoneVerify _twilioPhoneVerify;
  bool _isVisible = true;
  String phone;
  String phoneIsoCode;

  //final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final names = TextEditingController();
  final patsurname = TextEditingController();
  final matsurname = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isHidden = true;
  int CurrentStep = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _twilioPhoneVerify = TwilioPhoneVerify(
        accountSid: 'ACc621a266ebac6233618b310c1bcd30f6',
        serviceSid: 'VAec5e5ba5a0af7d933fb723ea0f8d196e',
        authToken: '744aa666d5b7d5eec2b344f048077c40');
    _focusNode.addListener(_focusNodeListener);
  }

  void dispose() {
    _focusNode.removeListener(
        _focusNodeListener); // ¡Este oyente debe cancelarse cuando la página desaparece! !
    super.dispose();
  }

  Future<Null> _focusNodeListener() async {
    // Use async para implementar este oyente
    if (_focusNode.hasFocus) {
      print('TextField got the focus');
    } else {
      print('TextField lost the focus');
    }
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phone = internationalizedPhoneNumber;
      phoneIsoCode = isoCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    RegExp regMayus = RegExp(r'^(?=.*?[A-Z]).{1,}');
    RegExp regMinus = RegExp(r'^(?=.*?[a-z]).{1,}');
    RegExp regNum2 = RegExp(r'^(?=.*?[0-9]).{1,}$');
    RegExp regChar = RegExp(r'^(?=.*?[$&+,:;=?@#|])(?=.*?[<>.-^*()%!]).{1}');
    return Form(
        key: _formKey,
        child: Theme(
          data: ThemeData(
            canvasColor: Color(0xff3B2F8F),
            colorScheme: ColorScheme.light(
              primary: Colors.orange,
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: size.height * 0.15),
            child: Stepper(
              elevation: 0,
              type: StepperType.horizontal,
              currentStep: CurrentStep,
              steps: getSteps(),
              onStepContinue: () async {
                final isLastStep = CurrentStep == getSteps().length - 1;
                final is2Step = CurrentStep == getSteps().length - 2;
                if (isLastStep) {
                  Navigator.pushNamed(context, '/');
                } else if (is2Step && _formKey.currentState.validate()) {
                  try {
                    await sendCode();
                    setState(() => CurrentStep += 1);
                  } catch (err) {
                    showErrorDialog(context, err);
                  }
                } else if (!_formKey.currentState.validate()) {
                  return;
                } else {
                  setState(() => CurrentStep += 1);
                }
              },
              onStepCancel: CurrentStep == 0
                  ? null
                  : () => setState(() => CurrentStep -= 1),
              controlsBuilder: (BuildContext context,
                  {onStepContinue, onStepCancel}) {
                Size size = MediaQuery.of(context).size;
                return Container(
                  margin: EdgeInsets.only(top: size.height * 0.01),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffF8991C), // background
                            onPrimary: Colors.white, // foreground
                          ),
                          child: Text('Continue'),
                          onPressed: onStepContinue,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      if (CurrentStep != 0)
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                onPrimary: Colors.white, // foreground
                                side: BorderSide(
                                  width: 3.0,
                                  color: Color(0xffF8991C),
                                )),
                            child: Text('Back'),
                            onPressed: onStepCancel,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ));
  }

  List<Step> getSteps() => [
        //Map data = ModalRoute.of(context).settings.arguments;
        Step(
          isActive: CurrentStep >= 0,
          title: Text(
            'Data',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: EdgeInsets.fromLTRB(18, 0, 30, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: InternationalPhoneInput(
                    enabledCountries: ['+91', '+1', '+52'],
                    errorText: 'no alphabetic and special characters',
                    errorMaxLines: 15,
                    errorStyle: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xffF8991C),
                    ),
                    decoration: InputDecoration(
                      errorStyle:
                          TextStyle(fontSize: 14.0, color: Color(0xffF8991C)),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Color(0xffF8991C), width: 2),
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
                      contentPadding: const EdgeInsets.only(left: 50),
                    ),
                    onPhoneNumberChange: onPhoneNumberChange,
                    initialPhoneNumber: phone,
                    initialSelection: 'MX',
                    showCountryCodes: true),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: names,
                  validator: (value) {
                    RegExp regNum2 = RegExp(r'^(?=.*?[0-9]).{1,}$');
                    RegExp regChar =
                        RegExp(r'^(?=.*?[$&+,:;=?@#|])(?=.*?[<>.-^*()%!]).{1}');
                    if (value.isEmpty) {
                      return 'Missing Names';
                    } else if (regNum2.hasMatch(value)) {
                      return 'The name does not have a number ';
                    } else if (regChar.hasMatch(value)) {
                      return 'no special characters';
                    } else if (value.length > 50) {
                      return 'Username length exceeded';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(fontSize: 14.0, color: Color(0xffF8991C)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: Color(0xffF8991C), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Names',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    hintText: 'Names',
                    hintTextDirection: TextDirection.rtl,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: patsurname,
                  validator: (value) {
                    RegExp regNum2 = RegExp(r'^(?=.*?[0-9]).{1,}$');
                    RegExp regChar =
                        RegExp(r'^(?=.*?[$&+,:;=?@#|])(?=.*?[<>.-^*()%!]).{1}');
                    RegExp regUser =
                        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z]).{6,12}');
                    if (value.isEmpty) {
                      return 'Missing Paternal surname';
                    } else if (regNum2.hasMatch(value)) {
                      return 'No numbers';
                    } else if (regChar.hasMatch(value)) {
                      return 'No special characters';
                    } else if (value.length > 24) {
                      return 'Paternal surname length exceeded';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(fontSize: 14.0, color: Color(0xffF8991C)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: Color(0xffF8991C), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Paternal surname',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    hintText: 'Paternal surname',
                    hintTextDirection: TextDirection.rtl,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: phoneIsoCode == 'MX' ? _isVisible : !_isVisible,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: matsurname,
                    validator: (value) {
                      RegExp regNum2 = RegExp(r'^(?=.*?[0-9]).{1,}$');
                      RegExp regChar = RegExp(
                          r'^(?=.*?[$&+,:;=?@#|])(?=.*?[<>.-^*()%!]).{1}');
                      RegExp regUser = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,12}');
                      if (value.isEmpty) {
                        return 'Missing Mothers surname';
                      } else if (regNum2.hasMatch(value)) {
                        return 'No number';
                      } else if (regChar.hasMatch(value)) {
                        return 'no special characters';
                      } else if (value.length > 24) {
                        return 'Mothers surname length exceeded';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      errorStyle:
                          TextStyle(fontSize: 14.0, color: Color(0xffF8991C)),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Color(0xffF8991C), width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Mothers surname',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                      hintText: 'Mothers surname',
                      hintTextDirection: TextDirection.rtl,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Step(
          isActive: CurrentStep >= 1,
          title: Text(
            'Account',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextFormField(
                  controller: usernameController,
                  validator: (value) {
                    RegExp regMayus = RegExp(r'^(?=.*?[A-Z]).{1,}');
                    RegExp regMinus = RegExp(r'^(?=.*?[a-z]).{1,}');
                    RegExp regNum2 = RegExp(r'^(?=.*?[0-9]).{1,}$');
                    RegExp regUser =
                        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,12}');
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
                      borderSide:
                          new BorderSide(color: Color(0xffF8991C), width: 2),
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
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    RegExp regMayus = RegExp(r'^(?=.*?[A-Z]).{1,}');
                    RegExp regMinus = RegExp(r'^(?=.*?[a-z]).{1,}');
                    RegExp regNum2 = RegExp(r'^(?=.*?[0-9]).{1,}$');
                    RegExp regChar =
                        RegExp(r'^(?=.*?[$&+,:;=?@#|])(?=.*?[<>.-^*()%!]).{1}');
                    RegExp regPass =
                        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,12}');
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
                      return 'Passcode length exceeded';
                    }
                    return null;
                  },
                  obscureText: _isHidden,
                  decoration: InputDecoration(
                    errorStyle:
                        TextStyle(fontSize: 14.0, color: Color(0xffF8991C)),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          new BorderSide(color: Color(0xffF8991C), width: 2),
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
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      borderSide:
                          new BorderSide(color: Color(0xffF8991C), width: 2),
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
            ],
          ),
        ),
        Step(
          isActive: CurrentStep >= 2,
          title: Text(
            'Code',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Text(
                    'Please enter the verification code',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Text(
                    'in the same order',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: OtpTextField(
                    fieldWidth: 45,
                    textStyle:
                        TextStyle(fontSize: 25, color: Color(0xffF8991C)),
                    numberOfFields: 6,
                    borderColor: Color(0xffF8991C),
                    focusedBorderColor: Color(0xffF8991C),
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    borderWidth: 3,
                    borderRadius: BorderRadius.circular(10),
                    onCodeChanged: (String value) {},
                    onSubmit: (smsCode) async {
                      /*
                    String cellphone = data['phone'];
                    String user = data['username'];
                    String names = data['names'];
                    String patSurname = data['patSurname'];
                    String matSurname = data['matSurname'];
                    String passcode = data['password'];
                    String isoCode = data['isoCode'];
                    */

                      if (phone.isEmpty && smsCode.isEmpty) return;
                      TwilioResponse twilioResponse = await _twilioPhoneVerify
                          .verifySmsCode(phone: phone, code: smsCode);
                      if (twilioResponse.successful) {
                        if (twilioResponse.verification.status ==
                            VerificationStatus.approved) {
                          print('Phone number is approved');
                          print(names);
                          ProgressDialog progressDialog = ProgressDialog(context);
                          progressDialog.show();
                          try {
                            await widget.deps.api.signup(
                              phone,
                              usernameController.text,
                              names.text,
                              patsurname.text,
                              matsurname.text,
                              passwordController.text,
                              phoneIsoCode,
                            );
                            ProgressDialog progressDialog = ProgressDialog(context);
                            progressDialog.dismissHome();
                            CoolAlert.show(
                                context: context,
                                backgroundColor: Color(0xffF8991C),
                                type: CoolAlertType.success,
                                title: "success",
                                text: "account successfully registered",
                                confirmBtnColor: Color(0xff3B2F8F),
                                onConfirmBtnTap: () async {
                                  Navigator.pushNamed(context, '/');
                                });
                          } catch (e) {
                            print(e);
                          }
                        } else {
                          print('Invalid code');
                        }
                      } else {
                        print(twilioResponse.errorMessage);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ];

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
                Navigator.pop(context);
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
    CoolAlert.show(
      context: context,
      type: CoolAlertType.error,
      title: err.title(),
      text: err.content(),
      confirmBtnColor: Color(0xff3B2F8F),
    );
  }

  void sendCode() async {
    if (phone.isEmpty) return;
    TwilioResponse twilioResponse = await _twilioPhoneVerify.sendSmsCode(phone);
    if (twilioResponse.successful) {
      print('Code sent to ${phone}');
      await Future.delayed(Duration(seconds: 1));
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        title: "Code sent ",
        text: "check your messages, the validation code has been sent.",
        confirmBtnColor: Color(0xff3B2F8F),
        backgroundColor: Color(0xffF8991C),
      );
    }
  }

/*maternalInput(){
    Size size = MediaQuery.of(context).size;
    switch (phoneIsoCode) {
                              case 'US':
                              return Container(
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.21, 0, 0),
                    padding: EdgeInsets.fromLTRB(30, 220, 30, 0),
                    child: TextFormField(
                      enabled: false,
                      controller: matsurname,
                      /*validator: (value) {
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
                      },*/
                      decoration: InputDecoration(
                        errorStyle:
                            TextStyle(fontSize: 14.0, color: Color(0xffF8991C)),
                        errorBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color(0xffF8991C), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Maternal surname',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        hintText: 'Maternal surname',
                        hintTextDirection: TextDirection.rtl,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                  );
                  case 'MX':
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.21, 0, 0),
                    padding: EdgeInsets.fromLTRB(30, 220, 30, 0),
                    child: TextFormField(
                      controller: matsurname,
                      /*validator: (value) {
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
                      },*/
                      decoration: InputDecoration(
                        errorStyle:
                            TextStyle(fontSize: 14.0, color: Color(0xffF8991C)),
                        errorBorder: OutlineInputBorder(
                          borderSide: new BorderSide(
                              color: Color(0xffF8991C), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Maternal surname',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        hintText: 'Maternal surname',
                        hintTextDirection: TextDirection.rtl,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(20),
                      ),
                    ),
                  );
                            };
  }*/
}
