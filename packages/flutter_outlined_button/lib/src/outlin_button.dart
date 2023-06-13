import 'package:flutter/material.dart';

class FlutterOutlinedButton extends StatelessWidget {
  final Function() onTap;
  final Function()? onLongPress;
  final double? radius;
  final double? fontSize;
  final Color? textColor;
  final String? buttonText;
  final double? borderThickness;
  final Color? buttonColor;
  final Color? borderColor;
  final Color? splashColor;
  const FlutterOutlinedButton({
    Key? key,
    required this.onTap,
    this.onLongPress,
    this.radius,
    this.borderColor,
    this.buttonColor,
    this.splashColor,
    this.fontSize,
    this.textColor,
    this.borderThickness,
    this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: buttonColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 0.0))
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        splashColor: splashColor,
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 0.0)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 0.0)),
            border: Border.all(
                width: borderThickness ?? 1,
                color: borderColor ?? Colors.black54,
            ),
          ),
          child: Text(
            buttonText ?? '',
            style: TextStyle(
              color: textColor ?? Colors.black54,
              fontSize: fontSize ?? 13,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}
