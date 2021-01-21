import 'package:flutter/material.dart';
import 'package:conellas/Screens/Login/login_screen.dart';
import 'package:conellas/Screens/Signup/components/background.dart';
import 'package:conellas/components/already_have_an_account_acheck.dart';
import 'package:conellas/components/rounded_button.dart';
import 'package:conellas/components/rounded_input_field.dart';
import 'package:conellas/components/rounded_password_field.dart';
import 'package:conellas/components/rounded_password_field2.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/logo.png",
              width: size.width * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedPasswordField2(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGN UP",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
