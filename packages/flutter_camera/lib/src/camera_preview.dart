import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_camera/src/camera_controller.dart';
import 'package:flutter_camera/src/loader/gradient_loader.dart';

/// A widget showing a live camera preview.
class CameraPreview extends StatefulWidget {
  /// Creates a preview widget for the given camera controller.
  const CameraPreview({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<CameraPreview> createState() => _CameraPreviewState();
}

class _CameraPreviewState extends State<CameraPreview> with TickerProviderStateMixin{
  late CameraController controller;
  bool status = false;
  bool onTakeImage = true;
  bool startRecordVideo = false;
  bool loadCamera = false;

  late AnimationController _animationController;

  void backCamera() async {
    setState(() {
      loadCamera = true;
    });
    controller = CameraController(widget.cameras[0], ResolutionPreset.ultraHigh);
    await controller.initialize().whenComplete((){
      Future.delayed(const Duration(milliseconds: 1500)).whenComplete((){
        setState(() {
          loadCamera = false;
        });
      });
    });
  }

  void frontCamera() async {
    setState(() {
      loadCamera = true;
    });
    controller = CameraController(widget.cameras[1], ResolutionPreset.ultraHigh);
    await controller.initialize().whenComplete((){
      Future.delayed(const Duration(milliseconds: 1500)).whenComplete((){
        setState(() {
          loadCamera = false;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
    backCamera();
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void imageOrVideo() async {
      onTakeImage = !onTakeImage;
      if(!onTakeImage){
        await controller.prepareForVideoRecording();
      }else{
        await controller.stopVideoRecording();
      }
      setState(() {});
  }

  void takePhotoOrVideo() async{
    if(onTakeImage){
      await controller.takePicture();
    }else{
      startRecordVideo = !startRecordVideo;
      setState(() {});
      if(startRecordVideo){
        await controller.stopVideoRecording();
      }else{
        await controller.startVideoRecording();
      }
    }
  }

  void levelZoom(){

  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: controller.value.isInitialized,
      child: controller.value.isInitialized
          ? ValueListenableBuilder<CameraValue>(
        valueListenable: controller,
        builder: (BuildContext context, Object? value, Widget? child) {
          return Stack(
            //fit: StackFit.expand,
            children: <Widget>[
              OrientationBuilder(
                builder: (context, orientation) {
                  return Transform.scale(
                    scaleX: orientation == Orientation.portrait ? 1.5 : 1,
                    child: _wrapInRotatedBox(child: controller.buildPreview()),
                  );
                },
              ),

              Positioned(
                  top: 50,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: MaterialButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            minWidth: 50,
                            height: 50,
                            elevation: 1,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(365)
                                )),
                            padding: const EdgeInsets.all(8),
                            color: Colors.white24,
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              Positioned(
                  bottom: 40,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: imageOrVideo,
                          minWidth: 70,
                          height: 70,
                          elevation: 1,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(365)
                              )),
                          padding: const EdgeInsets.all(8),
                          color: Colors.white38,
                          child: Icon(
                            onTakeImage ? Icons.photo_camera : Icons.videocam,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),

                        CameraSwitch(
                          value: status,
                          takeImageOrVideo: takePhotoOrVideo,
                          isRecord: startRecordVideo,
                          onVideoRecord: !onTakeImage,
                          changedCameraPosition: (value) {
                            setState(() {
                              status = value;
                            });
                            if(value){
                              frontCamera();
                            }else{
                             backCamera();
                            }
                          },
                        ),
                      ],
                    ),
                  )
              ),

              if(loadCamera)...[
                Center(
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 2.0).animate(_animationController),
                    child: const GradientCircularProgressIndicator(
                      radius: 30,
                      gradientColors: [
                        Colors.white24,
                        Colors.white,
                      ],
                      strokeWidth: 13.0,
                    ),
                  ),
                ),
              ]


              //loadCamera ?

                 // : SizedBox()
            ],
          );
        },
      )
          : Container(),
    );
  }

  Widget _wrapInRotatedBox({required Widget child}) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return child;
    }

    return RotatedBox(
      quarterTurns: _getQuarterTurns(),
      child: child,
    );
  }

  int _getQuarterTurns() {
    final Map<DeviceOrientation, int> turns = <DeviceOrientation, int>{
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeRight: 1,
      DeviceOrientation.portraitDown: 2,
      DeviceOrientation.landscapeLeft: 3,
    };
    return turns[_getApplicableOrientation()]!;
  }

  DeviceOrientation _getApplicableOrientation() {
    return controller.value.isRecordingVideo
        ? controller.value.recordingOrientation!
        : (controller.value.previewPauseOrientation ??
            controller.value.lockedCaptureOrientation ??
            controller.value.deviceOrientation);
  }
}


class CameraSwitch extends StatefulWidget {
  final bool value;
  final bool onVideoRecord;
  final bool isRecord;
  final ValueChanged<bool> changedCameraPosition;
  final VoidCallback takeImageOrVideo;

  const CameraSwitch({
    Key? key,
    required this.value,
    required this.onVideoRecord,
    required this.isRecord,
    required this.changedCameraPosition,
    required this.takeImageOrVideo,
  }) : super(key: key);

  @override
  State<CameraSwitch> createState() => _CameraSwitchState();
}

class _CameraSwitchState extends State<CameraSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this,
            duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.changedCameraPosition(true)
                : widget.changedCameraPosition(false);
          },
          child: Container(
            width: MediaQuery.of(context).size.width/1.7,
            height: 70,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration:  BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(45)),
              color: Colors.grey[350]!.withOpacity(0.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54.withOpacity(0.05),
                  offset: const Offset(2, 2),
                  spreadRadius: 2,
                  blurRadius: 2
                )
              ]
            ),
            child: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: widget.value ? ((Directionality.of(context) == TextDirection.rtl) ?
                        MainAxisAlignment.start : MainAxisAlignment.end ) :
                        ((Directionality.of(context) == TextDirection.rtl) ?
                        MainAxisAlignment.end : MainAxisAlignment.start),
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          if(widget.value)...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                          Text(
                            widget.value ? 'Back' : 'Front',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.6)
                            ),
                          ),
                          if(!widget.value)...[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],

                        ],
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 2.0, bottom: 2.0, right: 2.0, left: 2.0),
                  child: Align(
                    alignment:
                    widget.value ? ((Directionality.of(context) == TextDirection.rtl) ?
                    Alignment.centerRight : Alignment.centerLeft ) :
                    ((Directionality.of(context) == TextDirection.rtl) ?
                    Alignment.centerLeft : Alignment.centerRight),
                    child: MaterialButton(
                      onPressed: (){

                      },
                      elevation: 0,
                      minWidth: MediaQuery.of(context).size.width/3.5,
                      height: 60,
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(45))
                      ),
                      child: Icon(
                        widget.onVideoRecord ?
                        widget.isRecord ? Icons.stop :
                        Icons.fiber_manual_record : Icons.camera_alt,
                        color: Colors.black38,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


