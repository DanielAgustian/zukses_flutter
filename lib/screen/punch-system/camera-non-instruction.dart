import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/screen/punch-system/camera-clock-in.dart';

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
    // TODO: implement initState
    super.initState();
    getImage();
  }

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
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
                    "Directing to Next Page ... ",
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
}
