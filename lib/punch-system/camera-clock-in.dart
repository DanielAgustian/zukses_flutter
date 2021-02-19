import 'dart:io';

import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';

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
  void initState() {
    super.initState();
    imagePath = widget.path;
    _image = File(imagePath);
  }

  void photoApproval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Count In', true);
    print("Clock In Successs");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScreenTab()));
  }

  Widget build(BuildContext context) {
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
                            height: 350,
                            width: 310,
                          )),
                SizedBox(
                  height: 30,
                ),
                Text("Are you sure with this picture?",
                    style: TextStyle(
                        fontSize: 16,
                        color: colorPrimary,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        photoApproval();
                      },
                      child: Text("Continue",
                          style: TextStyle(
                              color: colorBackground,
                              fontWeight: FontWeight.bold)),
                      color: colorPrimary,
                    ),
                    SizedBox(width: 10),
                    RaisedButton(
                      onPressed: () {},
                      child: Text("Cancel",
                          style: TextStyle(color: colorBackground)),
                      color: Colors.red,
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
}
