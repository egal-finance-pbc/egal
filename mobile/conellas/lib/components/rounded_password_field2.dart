import 'package:flutter/material.dart';
import 'package:conellas/components/text_field_container.dart';
import 'package:conellas/constants.dart';

class RoundedPasswordField2 extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField2({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Confirm Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
