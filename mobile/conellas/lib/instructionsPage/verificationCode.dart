import 'package:flutter/material.dart';

class verificationCode extends StatefulWidget {
  const verificationCode({Key key}) : super(key: key);

  @override
  _verificationCodeState createState() => _verificationCodeState();
}

class _verificationCodeState extends State<verificationCode> {
  @override
  Widget build(BuildContext context) {
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
                      child: Container(
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: size.height * 0.07,
                                    width: size.height * 0.07,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: Color(0xffF8991C),
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                        child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                      validator: (value) {
                                        RegExp regMayus =
                                            RegExp(r'^(?=.*?[A-Z]).{1,}');
                                        RegExp regMinus =
                                            RegExp(r'^(?=.*?[a-z]).{1,}');
                                        RegExp regNum2 =
                                            RegExp(r'^(?=.*?[0-9]).{1,}$');
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
                                        errorStyle: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xffF8991C)),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Color(0xffF8991C),
                                              width: 2),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15, 30, 10, 0),
                                      ),
                                    )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: size.height * 0.07,
                                    width: size.height * 0.07,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: Color(0xffF8991C),
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                      validator: (value) {
                                        RegExp regMayus =
                                            RegExp(r'^(?=.*?[A-Z]).{1,}');
                                        RegExp regMinus =
                                            RegExp(r'^(?=.*?[a-z]).{1,}');
                                        RegExp regNum2 =
                                            RegExp(r'^(?=.*?[0-9]).{1,}$');
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
                                        errorStyle: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xffF8991C)),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Color(0xffF8991C),
                                              width: 2),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                        const EdgeInsets.fromLTRB(
                                            15, 30, 10, 0),
                                      ),
                                    )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: size.height * 0.07,
                                    width: size.height * 0.07,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: Color(0xffF8991C),
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                      validator: (value) {
                                        RegExp regMayus =
                                            RegExp(r'^(?=.*?[A-Z]).{1,}');
                                        RegExp regMinus =
                                            RegExp(r'^(?=.*?[a-z]).{1,}');
                                        RegExp regNum2 =
                                            RegExp(r'^(?=.*?[0-9]).{1,}$');
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
                                        errorStyle: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xffF8991C)),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Color(0xffF8991C),
                                              width: 2),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                        const EdgeInsets.fromLTRB(
                                            15, 30, 10, 0),
                                      ),
                                    )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    height: size.height * 0.07,
                                    width: size.height * 0.07,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: Color(0xffF8991C),
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                      textAlign: TextAlign.center,
                                      validator: (value) {
                                        RegExp regMayus =
                                            RegExp(r'^(?=.*?[A-Z]).{1,}');
                                        RegExp regMinus =
                                            RegExp(r'^(?=.*?[a-z]).{1,}');
                                        RegExp regNum2 =
                                            RegExp(r'^(?=.*?[0-9]).{1,}$');
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
                                        errorStyle: TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xffF8991C)),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: Color(0xffF8991C),
                                              width: 2),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                        const EdgeInsets.fromLTRB(
                                            15, 30, 10, 0),
                                      ),
                                    )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),

                              //Segunda serie de botones
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, size.height * 0.02, 0, 0),
                                    height: size.height * 0.07,
                                    width: size.height * 0.07,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: Color(0xffF8991C),
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          textAlign: TextAlign.center,
                                          validator: (value) {
                                            RegExp regMayus =
                                            RegExp(r'^(?=.*?[A-Z]).{1,}');
                                            RegExp regMinus =
                                            RegExp(r'^(?=.*?[a-z]).{1,}');
                                            RegExp regNum2 =
                                            RegExp(r'^(?=.*?[0-9]).{1,}$');
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
                                            errorStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffF8991C)),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Color(0xffF8991C),
                                                  width: 2),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15, 30, 10, 0),
                                          ),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, size.height * 0.02, 0, 0),
                                    height: size.height * 0.07,
                                    width: size.height * 0.07,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 3,
                                        color: Color(0xffF8991C),
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                          textAlign: TextAlign.center,
                                          validator: (value) {
                                            RegExp regMayus =
                                            RegExp(r'^(?=.*?[A-Z]).{1,}');
                                            RegExp regMinus =
                                            RegExp(r'^(?=.*?[a-z]).{1,}');
                                            RegExp regNum2 =
                                            RegExp(r'^(?=.*?[0-9]).{1,}$');
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
                                            errorStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xffF8991C)),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: new BorderSide(
                                                  color: Color(0xffF8991C),
                                                  width: 2),
                                            ),
                                            filled: true,
                                            fillColor: Colors.white,
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              borderSide: BorderSide.none,
                                            ),
                                            contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                15, 30, 10, 0),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
