import 'package:conellas/common/deps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';

class verificationCode extends StatefulWidget {
    final Dependencies deps;

  const verificationCode(this.deps, {Key key}) : super(key: key);

  @override
  _verificationCodeState createState() => _verificationCodeState();
}

class _verificationCodeState extends State<verificationCode> {
  
  TwilioPhoneVerify _twilioPhoneVerify;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _twilioPhoneVerify = TwilioPhoneVerify(
        accountSid: 'AC376189fed235dd2e7707b95f86b34c5a',
        serviceSid: 'VAb970c90d7a8937ee765360afebfe42f5',
        authToken: 'e30fa3d0b55d10c84832cfae1a2edc0d');
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffF8991C),
      appBar: AppBar(
        title: Text('Verification Code'),
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
                    height: size.height * 0.53,
                    //height: 320,
                    decoration: BoxDecoration(
                        color: Color(0xff3B2F8F),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        )),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, size.height * 0.12, 0, 0),
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
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
                      margin: EdgeInsets.fromLTRB(0, size.height * 0.16, 0, 0),
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
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
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.20, 0, 0),
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: OtpTextField(
                          numberOfFields: 6,
                          enabledBorderColor: Colors.orange,
                          focusedBorderColor: Colors.white,
                          cursorColor: Colors.black,
                          filled: true,
                          fillColor: Colors.white,
                          borderWidth: 2.0,
                          showFieldAsBox: true,
                          borderRadius: BorderRadius.circular(20),
                          onCodeChanged: (String value){},
                          onSubmit: (smsCode) async {

                            String cellphone = data['phone'];
                            String user = data['username'];
                            String passcode = data['password'];
                            String isoCode = data['isoCode'];

                            if (cellphone.isEmpty && smsCode.isEmpty) return;
                            TwilioResponse twilioResponse = await _twilioPhoneVerify.verifySmsCode(phone: cellphone, code: smsCode);
                            if (twilioResponse.successful) {
                              if (twilioResponse.verification.status == VerificationStatus.approved) {
                                print('Phone number is approved');
                                try {
                                  await widget.deps.api.signup(
                                    cellphone,
                                    user,
                                    passcode,
                                    isoCode,
                                  );
                                    showSuccessDialog(context);
                                }catch (e){
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
                  Container(
                    margin: EdgeInsets.fromLTRB(0, size.height * 0.68, 0, 0),
                    padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                    width: double.infinity,
                    height: size.height * 0.06,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff3B2F8F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      onPressed: () {},
                      child: Text(
                        'check',
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
}


void showSuccessDialog(BuildContext context) {
  Size size = MediaQuery.of(context).size;
  var successDialog = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    contentPadding: const EdgeInsets.all(20),
    actionsPadding: const EdgeInsets.only(top: 60),
    titlePadding: const EdgeInsets.all(20),
    title: Text("All ready"),
    content: Text("The number has been verified, you can now sign in"),
    actions: [
      Center(
        child: Container(
          width: size.width * 0.50,
          height: size.height * 0.06,
          child: FlatButton(
            color: Color(0xff3B2F8F),
            textColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: Text("OK"),
            onPressed: () {
              Navigator.pushNamed(context, '/');
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
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
