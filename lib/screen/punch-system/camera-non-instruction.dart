import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/punch-system/camera-clock-in.dart';
import 'package:easy_localization/easy_localization.dart';

class CameraNonInstruction extends StatefulWidget {
  CameraNonInstruction({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CameraNonInstructionScreen createState() => _CameraNonInstructionScreen();
}

class _CameraNonInstructionScreen extends State<CameraNonInstruction> {
  final picker = ImagePicker();
  bool loadingData = false;
  @override
  void initState() {
    // implement initState
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return loadingData
        ? Scaffold(
            body: Container(
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "home_text21".tr(),
                    style: TextStyle(color: colorPrimary),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            backgroundColor: colorBackground,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  // --------------------------Logic-----------------------------//

  void getImage() async {
    try {
      final pickedFile = await picker.pickImage(
          preferredCameraDevice: CameraDevice.front,
          source: ImageSource.camera,
          imageQuality: imageQualityCamera,
          maxHeight: maxHeight,
          maxWidth: maxWidth);
      if (pickedFile != null) {
        setState(() {
          loadingData = true;
        });
        String data = pickedFile.path;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => PreviewCamera(
                      path: data,
                    )));
      } else {
        Navigator.pop(context);
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
