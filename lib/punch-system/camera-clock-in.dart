import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-bloc.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-event.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-state.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/util/util.dart';

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
  bool uploading = false;
  DateTime now = DateTime.now();

  void initState() {
    super.initState();
    imagePath = widget.path;
    _image = File(imagePath);
    print(imagePath);
  }

//For shared preferences clock IN
  addClockInSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counter = 1;
    await prefs.setInt(key, counter);
    // TO CHECKING when start the APP
    // Is the date is same or not
    // If id doesn't same, then it should reset `clock in` status into 0
    // Else keep the `clock in` status
    await prefs.setInt("tanggal", now.day);
  }

  void timer(BuildContext contextTimer) {
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          Navigator.pop(contextTimer);
          //Navigator.pop(contextTimer);
        });
      }
    });
  }

  void clockIn() {
    setState(() {
      uploading = true;
    });
    BlocProvider.of<AttendanceBloc>(context)
        .add(AttendanceClockIn(image: _image));
  }

  void retakeButton() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    String newImage = pickedFile.path;
    setState(() {
      _image = File(newImage);
    });
  }

  BuildContext mContext;
  Widget build(BuildContext context) {
    mContext = this.context;
    Size size = MediaQuery.of(context).size;
    return BlocListener<AttendanceBloc, AttendanceState>(
      listener: (context, state) async {
        if (state is AttendanceStateFailed) {
          setState(() {
            uploading = false;
          });
          Util().showToast(
              context: this.context,
              msg: "Something Wrong !",
              color: colorError,
              txtColor: colorBackground);
        } else if (state is AttendanceStateSuccessClockIn) {
          setState(() {
            uploading = false;
          });
          addClockInSF();
          _buildPopupDialog(context);
          // timer(mContext);
          // Navigator.pop(context);
          //Navigator.pop(context);

        }
      },
      child: Scaffold(
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
                          // pushtoScreenTab();
                          clockIn();
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
                              border:
                                  Border.all(width: 2, color: colorPrimary)),
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
              uploading
                  ? Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.black38.withOpacity(0.5),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: colorPrimary70,
                          // strokeWidth: 0,
                          valueColor: AlwaysStoppedAnimation(colorBackground),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new CupertinoAlertDialog(
      title: Text(
        "Clock In Success!",
        style: TextStyle(color: colorPrimary, fontWeight: FontWeight.bold),
      ),
      content: new Text("This is my content"),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ScreenTab()));
            })
      ],
    );
  }
}
