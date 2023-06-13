import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// States that your button can assume via the controller
// ignore: public_member_api_docs
enum ButtonState { idle, loading, success, error }

/// Initialize class
class FlutterLoadingButton extends StatefulWidget {
  final double? fontSize;
  final Color? textColor;
  final String? buttonText;
  final RoundedLoadingButtonController controller;
  final VoidCallback? onPressed;
  final Color? color;
  final double loaderSize;
  final double loaderStrokeWidth;
  final bool animateOnTap;
  final Color valueColor;
  final Curve curve;
  final double borderRadius;
  final Duration duration;
  final double elevation;
  final VoidCallback? onLongPress;
  final double? radius;
  final Color? buttonColor;
  final Color? splashColor;
  final Color? errorButtonColor;

  /// The color of the button when it is in the success state
  final Color? successColor;

  /// The color of the button when it is disabled
  final Color? disabledColor;

  /// The icon for the success state
  final IconData successIcon;

  /// The icon for the failed state
  final IconData failedIcon;

  /// The success and failed animation curve
  final Curve completionCurve;

  /// The duration of the success and failed animation
  final Duration completionDuration;

  Duration get _borderDuration {
    return Duration(milliseconds: (duration.inMilliseconds / 2).round());
  }

  /// initialize constructor
  const FlutterLoadingButton({
    Key? key,
    required this.controller,
    required this.onPressed,
    this.color = Colors.lightBlue,
    this.loaderSize = 24.0,
    this.loaderStrokeWidth = 2.0,
    this.animateOnTap = true,
    this.valueColor = Colors.white,
    this.borderRadius = 35,
    this.elevation = 2,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOutCirc,
    this.errorButtonColor = Colors.red,
    this.successColor = Colors.green,
    this.successIcon = Icons.check,
    this.failedIcon = Icons.close,
    this.completionCurve = Curves.elasticOut,
    this.completionDuration = const Duration(milliseconds: 1000),
    this.disabledColor,
    this.buttonText,
    this.textColor,
    this.fontSize,
    this.splashColor,
    this.onLongPress,
    this.buttonColor,
    this.radius,
    // required this.height,
    // required this.width,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => FlutterLoadingButtonState();
}

/// Class implementation
class FlutterLoadingButtonState extends State<FlutterLoadingButton>
    with TickerProviderStateMixin {
  late AnimationController _buttonController;
  late AnimationController _borderController;
  late AnimationController _checkButtonController;

  late Animation _squeezeAnimation;
  late Animation _bounceAnimation;
  late Animation _borderAnimation;

  final _state = BehaviorSubject<ButtonState>.seeded(ButtonState.idle);


  Widget button(){
    return MaterialButton(
      minWidth: _squeezeAnimation.value,
      height: 50,
      onPressed: widget.onPressed,
      onLongPress: widget.onLongPress,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 0))
      ),
      elevation: widget.elevation,
      color: widget.buttonColor,
      splashColor: widget.splashColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
        child: childStream(),
      ),
    );
  }

  Widget successButton() {
    return MaterialButton(
        onPressed: (){
          _reset();
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 0))
        ),
        elevation: widget.elevation,
        color: widget.successColor ?? Colors.black54,
        minWidth: _bounceAnimation.value,
        height: _bounceAnimation.value,
        child: _bounceAnimation.value > 20
            ? Icon(
          widget.successIcon,
          color: widget.valueColor,
        ) : null
    );
  }

  Widget errorButton() {
    return MaterialButton(
      onPressed: (){
        _reset();
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.radius ?? 0))
      ),
      elevation: widget.elevation,
      color: widget.errorButtonColor,
        minWidth: _bounceAnimation.value,
        height: _bounceAnimation.value,
      child: _bounceAnimation.value > 20
          ? Icon(
        widget.failedIcon,
        color: widget.valueColor,
      ) : null
    );
  }

  Widget loader() {
    return SizedBox(
      height: widget.loaderSize,
      width: widget.loaderSize,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(widget.valueColor),
        strokeWidth: widget.loaderStrokeWidth,
      ),
    );
  }

  Widget childStream() {
    return StreamBuilder(
      stream: _state,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: snapshot.data == ButtonState.loading
              ? loader()
              : Text(
                  widget.buttonText ?? '',
                  style: TextStyle(
                      color: widget.textColor ?? Colors.black54,
                      fontSize: widget.fontSize ?? 13,
                      fontWeight: FontWeight.bold),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _state.value == ButtonState.error
          ? errorButton()
          : _state.value == ButtonState.success
          ? successButton()
          : button(),
    );
  }

  @override
  void initState() {
    super.initState();

    _buttonController =
        AnimationController(duration: widget.duration, vsync: this);

    _checkButtonController =
        AnimationController(duration: widget.completionDuration, vsync: this);

    _borderController =
        AnimationController(duration: widget._borderDuration, vsync: this);

    _bounceAnimation = Tween<double>(begin: 0, end: 50).animate(
      CurvedAnimation(
        parent: _checkButtonController,
        curve: widget.completionCurve,
      ),
    );
    _bounceAnimation.addListener(() {
      setState(() {});
    });

    _squeezeAnimation =
        Tween<double>(begin: 10, end: 50).animate(
          CurvedAnimation(parent: _buttonController, curve: widget.curve),
        );

    _squeezeAnimation.addListener(() {
      setState(() {});
    });

    _squeezeAnimation.addStatusListener((state) {
      if (state == AnimationStatus.completed && widget.animateOnTap) {
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      }
    });

    _borderAnimation = BorderRadiusTween(
      begin: BorderRadius.circular(widget.borderRadius),
      end: BorderRadius.circular(50),
    ).animate(_borderController);

    _borderAnimation.addListener(() {
      setState(() {});
    });

    // There is probably a better way of doing this...
    _state.stream.listen((event) {
      if (!mounted) return;
      widget.controller._state.sink.add(event);
    });

    widget.controller._addListeners(_start, _stop, _success, _error, _reset);
  }

  @override
  void dispose() {
    _buttonController.dispose();
    _checkButtonController.dispose();
    _borderController.dispose();
    _state.close();
    super.dispose();
  }

  void _btnPressed() async {
    if (widget.animateOnTap) {
      _start();
    } else {
      if (widget.onPressed != null) {
        widget.onPressed!();
      }
    }
  }

  void _start() {
    if (!mounted) return;
    _state.sink.add(ButtonState.loading);
    _borderController.forward();
    _buttonController.forward();
  }

  void _stop() {
    if (!mounted) return;
    _state.sink.add(ButtonState.idle);
    _buttonController.reverse();
    _borderController.reverse();
  }

  void _success() {
    if (!mounted) return;
    _state.sink.add(ButtonState.success);
    _checkButtonController.forward();
  }

  void _error() {
    if (!mounted) return;
    _state.sink.add(ButtonState.error);
    _checkButtonController.forward();
  }

  void _reset() async {
    _state.sink.add(ButtonState.idle);
    unawaited(_buttonController.reverse());
    unawaited(_borderController.reverse());
    _checkButtonController.reset();
  }
}

/// Options that can be chosen by the controller
/// each will perform a unique animation
class RoundedLoadingButtonController {
  VoidCallback? _startListener;
  VoidCallback? _stopListener;
  VoidCallback? _successListener;
  VoidCallback? _errorListener;
  VoidCallback? _resetListener;

  void _addListeners(
      VoidCallback startListener,
      VoidCallback stopListener,
      VoidCallback successListener,
      VoidCallback errorListener,
      VoidCallback resetListener,
      ) {
    _startListener = startListener;
    _stopListener = stopListener;
    _successListener = successListener;
    _errorListener = errorListener;
    _resetListener = resetListener;
  }

  final BehaviorSubject<ButtonState> _state =
  BehaviorSubject<ButtonState>.seeded(ButtonState.idle);

  /// A read-only stream of the button state
  Stream<ButtonState> get stateStream => _state.stream;

  /// Gets the current state
  ButtonState? get currentState => _state.value;

  /// Notify listeners to start the loading animation
  void start() {
    if (_startListener != null) _startListener!();
  }

  /// Notify listeners to start the stop animation
  void stop() {
    if (_stopListener != null) _stopListener!();
  }

  /// Notify listeners to start the success animation
  void success() {
    if (_successListener != null) _successListener!();
  }

  /// Notify listeners to start the error animation
  void error() {
    if (_errorListener != null) _errorListener!();
  }

  /// Notify listeners to start the reset animation
  void reset() {
    if (_resetListener != null) _resetListener!();
  }
}