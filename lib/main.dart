import 'package:flutter/material.dart';
import 'package:flutter_card/flutter_card.dart';
import 'package:flutter_loading_button/flutter_loading_button.dart';
import 'package:flutter_outlined_button/flutter_outlined_button.dart';
import 'package:flutter_simple_button/flutter_simple_button.dart';
import 'package:flutter_textfield/flutter_textfield.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter_camera/src/camera_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListOfWidgets(),
    );
  }
}

class ListOfWidgets extends StatefulWidget {
  const ListOfWidgets({Key? key}) : super(key: key);

  @override
  State<ListOfWidgets> createState() => _ListOfWidgetsState();
}

class _ListOfWidgetsState extends State<ListOfWidgets> {
  TextEditingController textEditingController = TextEditingController();
  bool unFocus = false;

  RoundedLoadingButtonController buttonController = RoundedLoadingButtonController();

  late List<CameraDescription> _cameras;
  void getCameras() async{
    _cameras = await availableCameras();
  }

  void resetButton() {
    buttonController.start();
    Future.delayed(const Duration(seconds: 2)).whenComplete(() {
      buttonController.error();
    });
  }

  @override
  void initState() {
    getCameras();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () {
            unFocus = true;
            setState(() {});
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50,),
              FlutterTextField(
                  hint: '',
                  unFocus: unFocus,
                  onTap: () {
                    unFocus = false;
                    setState(() {});
                  },
                  controller: textEditingController,
                  onChanged: (c) {}
              ),
              const SizedBox(height: 50,),
              FlutterCard(
                width: 100,
                height: 100,
                cardColor: Colors.white,
                radius: 15,
                useShadow: true,
                offset: const Offset(0, 0),
                blurRadius: 15,
                spreadRadius: 5,
                shadowColor: Colors.deepOrange.withOpacity(0.2),
              ),
              const SizedBox(height: 50,),
              FlutterCard(
                width: 100,
                height: 100,
                cardColor: Colors.white,
                radius: 15,
                useShadow: true,
                offset: const Offset(0, 0),
                blurRadius: 15,
                spreadRadius: 5,
                shadowColor: Colors.blue.withOpacity(0.2),
              ),
              const SizedBox(height: 50,),
              FlutterOutlinedButton(
                buttonText: 'outlined button',
                splashColor: Colors.blue,
                buttonColor: Colors.amber,
                radius: 5,
                onTap: () {},
              ),
              const SizedBox(height: 10,),
              FlutterSimpleButton(
                onTap: () {},
                buttonColor: Colors.purple,
                elevation: 10,
                splashColor: Colors.cyan,
                buttonText: 'simple button',
                radius: 5,
              ),
              const SizedBox(height: 10,),
              FlutterLoadingButton(
                onPressed: () {
                  resetButton();
                },
                controller: buttonController,
                buttonColor: Colors.greenAccent,
                buttonText: 'loader button',
                radius: 5,
                elevation: 3,
              ),

              // IconButton(
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => FlutterCamera(cameras: _cameras,)),
              //       );
              //     },
              //     icon: const Icon(Icons.camera)
              // )
            ],
          ),
        ),
      ),
    );
  }
}
