import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zukses_app_1/component/button/button-small.dart';
import 'package:zukses_app_1/model/google-sign-in-model.dart';
import 'package:easy_localization/easy_localization.dart';
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
  bool closing = false;
  Util util = Util();
  String tokenFCM;
  void initState() {
    super.initState();
    imagePath = widget.path;
    _image = File(imagePath);
    print(imagePath);
  }

  BuildContext mContext;
  Widget build(BuildContext context) {
    mContext = this.context;
    Size size = MediaQuery.of(context).size;
    return BlocListener<AttendanceBloc, AttendanceState>(
      listener: (context, state) async {
        if (state is AttendanceStateFailed) {
          uploading = false;
          Util().showToast(
              context: this.context,
              msg: "Something Wrong !",
              color: colorError,
              txtColor: colorBackground);
        } else if (state is AttendanceStateSuccessClockIn) {
          addClockInSF();
          uploading = false;
          await showDialog(
              context: context,
              builder: (BuildContext context) =>
                  _buildPopupDialog(mContext)).then((value) {
            checkStatusClock();
            Navigator.pop(context);
          });
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text("confirm_clock_in".tr(),
                        style: TextStyle(
                            fontSize: size.height < 600 ? 16 : 18,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Text(
                                "retake_text".tr(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: colorPrimary,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      SmallButton(
                        size: 120,
                        title: "continue_text".tr(),
                        bgColor: colorPrimary,
                        textColor: colorBackground,
                        onClick: () {
                          // FOr Clock in
                          clockIn();
                        },
                      ),
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
      title: new Text(
        "Clock In " + "success_text".tr() + " !",
      ),
      content: new Text("Clock In Time: " + Util().hourFormat(DateTime.now())),
      actions: <Widget>[
        CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                closing = true;
              });
            })
      ],
    );
  }

// --------------------------Logic-----------------------------//

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

  void clockIn() {
    setState(() {
      uploading = true;
    });
    if (_image != null) {
      BlocProvider.of<AttendanceBloc>(context)
          .add(AttendanceClockIn(image: _image));
    } else {
      Util().showToast(
          msg: "Image Empty",
          context: context,
          duration: 3,
          color: colorError,
          txtColor: colorBackground);
    }
  }

  void retakeButton() async {
    final pickedFile = await picker.getImage(
        preferredCameraDevice: CameraDevice.front,
        source: ImageSource.camera,
        imageQuality: imageQualityCamera,
        maxHeight: maxHeight,
        maxWidth: maxWidth);

    String newImage = pickedFile.path;

    setState(() {
      _image = File(newImage);
    });
  }

  void getAuthData() async {
    await _getTokenFCM();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("userLogin");
    String password = prefs.getString("passLogin");
    print("username " + username);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthEventLoginManual(
        email: username, password: password, tokenFCM: tokenFCM));
  }

  void checkStatusClock() async {
    print("CheckStatusClock Jalan");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var googleSign = prefs.getInt('google');
    var facebookSign = prefs.getInt('facebook');
    print("Allow Google Sign " + googleSign.toString());
    if (googleSign != null) {
      getAuthGoogle();
    } else if (facebookSign != null) {
    } else {
      getAuthData();
    }
  }

  Future<void> _getTokenFCM() async {
    tokenFCM = await util.getTokenFCM();
  }

  void getAuthGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('google_data');
    GoogleSignInModel model = GoogleSignInModel.fromJson(jsonDecode(data));
    print("Email from Google = " + model.email);
    BlocProvider.of<AuthenticationBloc>(context).add(
        AuthEventDetectGoogleSignIn(
            email: model.email,
            name: model.name,
            image: model.image,
            tokenGoogle: model.token,
            tokenFCM: tokenFCM));
  }
}
