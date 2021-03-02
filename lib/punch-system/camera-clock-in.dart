import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/component/button/button-small.dart';

class PreviewCamera extends StatefulWidget {
  PreviewCamera({Key key, this.title, this.path}) : super(key: key);

  final String title;
  final String path;
  @override
  _PreviewCameraScreen createState() => _PreviewCameraScreen();
}

class _PreviewCameraScreen extends State<PreviewCamera> {
  File _image;
  String imagePath;
  String key = "clock in";
  final picker = ImagePicker();
  void initState() {
    super.initState();
    imagePath = widget.path;
    _image = File(imagePath);

    //addBoolClockIn();
  }

  addClockInSF() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = 1;
    await prefs.setInt(key, counter);
  }

  pushtoScreenTab() async {
    addClockInSF();
    //TempLog(namaProses: "Clock In", nilai: true);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScreenTab()));
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: _image == null
                        ? Text('No image selected.')
                        : Image.file(
                            _image,
                            height: size.height < 600 ? 350 : 400,
                            width: size.height < 600 ? 310 : 360,
                          )),
                SizedBox(
                  height: 30,
                ),
                Text("Are you sure with this picture?",
                    style: TextStyle(
                        fontSize: size.height < 600 ? 16 : 18,
                        color: colorPrimary,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SmallButton(
                      size: 120,
                      title: "Continue",
                      bgColor: colorPrimary,
                      textColor: colorBackground,
                      onClick: () {
                        pushtoScreenTab();
                      },
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        retakeButton();
                      },
                      child: Container(
                        width: 120,
                        height: 35,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        decoration: BoxDecoration(
                            color: colorBackground,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: colorPrimary)),
                        child: Center(
                          child: Text(
                            "Retake",
                            style: TextStyle(
                                fontSize: 16,
                                color: colorPrimary,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void retakeButton() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    String newImage = pickedFile.path;
    setState(() {
      _image = File(newImage);
    });
  }
}
