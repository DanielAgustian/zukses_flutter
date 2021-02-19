import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/punch-system/camera-clock-in.dart';

import 'package:image_picker/image_picker.dart';

class CameraInstruction extends StatefulWidget {
  CameraInstruction({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CameraInstructionScreen createState() => _CameraInstructionScreen();
}

class _CameraInstructionScreen extends State<CameraInstruction> {
  bool dontShowAgain = false;
  final picker = ImagePicker();
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration:
                BoxDecoration(color: colorPrimary, shape: BoxShape.circle),
          ),
          //Image(image: AssetImage('assets/images/camera-placeholder.png')),
          SizedBox(
            height: 20,
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 30, 40, 0),
                child: Text("Good Lighting",
                    style: TextStyle(color: colorPrimary50, fontSize: 14)),
              )),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                child: Text("Make sure you take a photo with good lighting,",
                    style: TextStyle(color: colorPrimary, fontSize: 14)),
              )),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                child: Text("Ready in Your Seat",
                    style: TextStyle(color: colorPrimary50, fontSize: 14)),
              )),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                child: Text(
                    "Let's touch up and go to bath for the admin to prepare for the day! Slick man and beautiful girl, let's go!",
                    style: TextStyle(color: colorPrimary, fontSize: 14)),
              )),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                child: Text("Take a Your Photo",
                    style: TextStyle(color: colorPrimary50, fontSize: 14)),
              )),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                child: Text(
                    "Let's take a picture and give your best smile for the admin! Begin our work in this beautiful day!",
                    style: TextStyle(color: colorPrimary, fontSize: 14)),
              )),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                  value: dontShowAgain, onChanged: _onDontShowAgainChanged),
              Text("Dont Show Again",
                  style: TextStyle(fontSize: 12, color: colorPrimary)),
            ],
          ),

          ButtonTheme(
            minWidth: 200.0,
            child: RaisedButton(
              color: colorPrimary,
              child: Text("Continue",
                  style: TextStyle(
                      fontSize: 16,
                      color: colorBackground,
                      fontWeight: FontWeight.bold)),
              onPressed: (continueButton),
            ),
          )
        ],
      ),
    );
  }

  void _onDontShowAgainChanged(bool newValue) => setState(() {
        dontShowAgain = newValue;

        if (dontShowAgain) {
          print("I wont show again. Sorry to bother you.");
        } else {
          // TODO: Forget the user
          print("We will meet again");
        }
      });

  void continueButton() async {
    //WidgetsFlutterBinding.ensureInitialized();
    //final cameras = await availableCameras();
    /*Navigator.push(
        context, MaterialPageRoute(builder: (context) => CameraClockIn()));*/
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        String data = pickedFile.path;
        //print(data);
        //_image = File(pickedFile.path);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewCamera(
                      path: data,
                    )));
      });
    }
  }
}
