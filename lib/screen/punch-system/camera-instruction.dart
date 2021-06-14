import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/screen/punch-system/camera-clock-in.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:easy_localization/easy_localization.dart';

class CameraInstruction extends StatefulWidget {
  CameraInstruction({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CameraInstructionScreen createState() => _CameraInstructionScreen();
}

class _CameraInstructionScreen extends State<CameraInstruction> {
  bool dontShowAgain = false;
  final picker = ImagePicker();
  bool waiting = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return waiting
        ? Scaffold(
            backgroundColor: colorBackground,
            body: Container(
              width: size.width,
              padding: EdgeInsets.all(20),
              color: colorBackground,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor: colorPrimary,
                          radius: size.height <= 569 ? 60 : 90,
                        ),
                      ),
                      //Image(image: AssetImage('assets/images/camera-placeholder.png')),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Text("instruction_text1".tr(),
                            style: TextStyle(
                                color: colorPrimary50,
                                fontSize: size.height <= 569 ? 14 : 16)),
                      ),
                      SizedBox(
                        height: size.height <= 569 ? 5 : 10,
                      ),
                      Container(
                        child: Text("instruction_text2".tr(),
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: size.height <= 569 ? 14 : 16)),
                      ),
                      SizedBox(height: size.height <= 569 ? 10 : 15),
                      Container(
                        child: Text("instruction_text3".tr(),
                            style: TextStyle(
                                color: colorPrimary50,
                                fontSize: size.height <= 569 ? 14 : 16)),
                      ),
                      SizedBox(
                        height: size.height <= 569 ? 5 : 10,
                      ),
                      Container(
                        child: Text("instruction_text4".tr(),
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: size.height <= 569 ? 14 : 16)),
                      ),
                      SizedBox(height: size.height <= 569 ? 10 : 15),
                      Container(
                        child: Text("instruction_text5".tr(),
                            style: TextStyle(
                                color: colorPrimary50,
                                fontSize: size.height <= 569 ? 14 : 16)),
                      ),
                      SizedBox(
                        height: size.height <= 569 ? 5 : 10,
                      ),
                      Container(
                        child: Text("instruction_text6".tr(),
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: size.height <= 569 ? 14 : 16)),
                      ),
                      SizedBox(
                        height: size.height <= 569 ? 25 : 40,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                            width: size.width * 0.65,
                            child: CheckboxListTile(
                              value: dontShowAgain,
                              onChanged: _onDontShowAgainChanged,
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text("instruction_text7".tr(),
                                  style: TextStyle(
                                      fontSize: size.height <= 569 ? 12 : 14,
                                      color: colorPrimary,
                                      fontWeight: FontWeight.bold)),
                            )),
                      ),

                      SizedBox(
                        height: size.height <= 569 ? 25 : 40,
                      ),
                      LongButton(
                        size: size,
                        bgColor: colorPrimary,
                        textColor: colorBackground,
                        title: "continue_text".tr(),
                        onClick: continueButton,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            body: Container(
              color: colorBackground,
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    "home_text21".tr(),
                    style: TextStyle(color: colorPrimary),
                  )
                ],
              ),
            ),
          );
  }

  // --------------------------Logic-----------------------------//

  void _onDontShowAgainChanged(bool newValue) => setState(() {
        dontShowAgain = newValue;
        changeSharedPreferences(dontShowAgain);
        if (dontShowAgain) {
          print("I wont show again. Sorry to bother you.");
        } else {
          //Forget the user
          print("We will meet again");
        }
      });

  void continueButton() async {
    setState(() {
      waiting = false;
    });
    final pickedFile = await picker.getImage(
        preferredCameraDevice: CameraDevice.front,
        source: ImageSource.camera,
        imageQuality: imageQualityCamera,
        maxHeight: maxHeight,
        maxWidth: maxWidth);
    if (pickedFile != null) {
      setState(() {
        String data = pickedFile.path;
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewCamera(
                      path: data,
                    )));
      });
    } else {
      setState(() {
        waiting = true;
      });
    }
  }

  void changeSharedPreferences(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("instruction", value);
      print("instruction changed to " + value.toString());
    });
  }
}
