import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/src/camera_preview.dart';

class FlutterCamera extends StatefulWidget {
  final List<CameraDescription> cameras;
  const FlutterCamera({Key? key, required this.cameras}) : super(key: key);

  @override
  State<FlutterCamera> createState() => _FlutterCameraState();
}

class _FlutterCameraState extends State<FlutterCamera> {
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CameraPreview(
      cameras: widget.cameras,
    ));
  }
}
