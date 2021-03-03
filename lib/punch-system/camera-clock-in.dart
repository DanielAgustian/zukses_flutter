import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/API/attendance-services.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-bloc.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-event.dart';
import 'package:zukses_app_1/bloc/attendance/attendance-state.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
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

  AttendanceService _attendService = AttendanceService();

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
    var res = await _attendService.createClockIn(_image);

    if (res == 200) {
      addClockInSF();
      //TempLog(namaProses: "Clock In", nilai: true);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ScreenTab()));
    }
  }

  void clockIn() {
    BlocProvider.of<AttendanceBloc>(context)
        .add(AttendanceClockIn(image: _image));
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<AttendanceBloc, AttendanceState>(
      listener: (context, state) async {
        if (state is AttendanceStateFailed) {
          Util().showToast(
              context: this.context,
              msg: "Something Wrong !",
              color: colorError,
              txtColor: colorBackground);
        } else if (state is AttendanceStateSuccessClockIn) {
          addClockInSF();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ScreenTab()));
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
            ],
          ),
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
