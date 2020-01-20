import 'package:flutter/material.dart';
import 'package:tolymoly/constants/color_constant.dart';
import 'package:tolymoly/enum/button_type_enum.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onPressed;
  final ButtonTypeEnum buttonTypeEnum;
  // final double borderRadius = 30;
  final double fontSize = 18;

  CustomButton(
      {@required this.onPressed,
      @required this.text,
      @required this.buttonTypeEnum});

  @override
  Widget build(BuildContext context) {
    Color buttonColor;
    Color textColor;
    Widget button;

    switch (buttonTypeEnum) {
      case ButtonTypeEnum.primary:
        buttonColor = ColorConstant.primary;
        textColor = Colors.white;
        button = _buildFlatButton(buttonColor, textColor);
        break;
      case ButtonTypeEnum.origin:
        buttonColor = ColorConstant.origin;
        textColor = ColorConstant.origin;
        button = _buildOutlineButton(buttonColor, textColor);
        break;
      case ButtonTypeEnum.facebook:
        buttonColor = ColorConstant.facebook;
        textColor = Colors.white;
        button = _buildFlatButton(buttonColor, textColor);
        break;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: button,
    );
  }

  Widget _buildFlatButton(Color buttonColor, Color textColor) {
    return FlatButton(
      onPressed: onPressed,
      shape: StadiumBorder(),
      color: buttonColor,
      child: Text(text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          )),
    );
  }

  Widget _buildOutlineButton(Color buttonColor, Color textColor) {
    return OutlineButton(
      onPressed: onPressed,
      borderSide: BorderSide(color: buttonColor),
      shape: StadiumBorder(),
      child: Text(text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
          )),
    );
  }
}
