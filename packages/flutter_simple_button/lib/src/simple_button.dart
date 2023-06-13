import 'package:flutter/material.dart';

class FlutterSimpleButton extends StatelessWidget {
  final Function() onTap;
  final Function()? onLongPress;
  final double? radius;
  final double? fontSize;
  final double? elevation;
  final Color? buttonColor;
  final Color? textColor;
  final Color? splashColor;
  final String? buttonText;

  const FlutterSimpleButton({
    Key? key,
    required this.onTap,
    this.onLongPress,
    this.radius,
    this.buttonColor,
    this.splashColor,
    this.fontSize,
    this.textColor,
    this.elevation,
    this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      onLongPress: onLongPress,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 0))
      ),
      elevation: elevation,
      color: buttonColor,
      splashColor: splashColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        child: Text(
          buttonText ?? '',
          style: TextStyle(
              color: textColor ?? Colors.black54,
              fontSize: fontSize ?? 13,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
