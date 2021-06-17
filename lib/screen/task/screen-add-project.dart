import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';
import 'package:zukses_app_1/component/button/button-long-outlined.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/project-model.dart';
import 'package:zukses_app_1/util/util.dart';
import 'package:recase/recase.dart';
import 'package:easy_localization/easy_localization.dart';

class AddProject extends StatefulWidget {
  AddProject({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AddProjectScreen createState() => _AddProjectScreen();
}

/// This is the stateless widget that the main application instantiates.
class _AddProjectScreen extends State<AddProject> {
  Util util = Util();
  final textTitle = TextEditingController();
  final textDetails = TextEditingController();
  String data = "";
  bool loading = false;
  final picker = ImagePicker();
  bool _titleValidator = false;
  bool _detailValidator = false;

  Future<bool> onWillPop(Size size) async {
    return (await showDialog(
            context: context,
            barrierColor: Colors.white.withOpacity(0.5),
            builder: (BuildContext context) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          "schedule_text8".tr(),
                          style: TextStyle(color: colorPrimary, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      LongButton(
                        size: size,
                        bgColor: colorPrimary,
                        textColor: colorBackground,
                        title: "schedule_text9".tr(),
                        onClick: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      LongButtonOutline(
                        outlineColor: colorError,
                        size: size,
                        bgColor: colorBackground,
                        textColor: colorError,
                        title: "schedule_text10".tr(),
                        onClick: () {
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                          /*Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      (ScreenTab(index: 3))));*/
                        },
                      )
                    ],
                  ),
                ),
              );
            })) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorBackground,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: colorPrimary,
          ),
          onPressed: () {
            if (textTitle.text.length > 0 ||
                textDetails.text.length > 0 ||
                data != "")
              onWillPop(size);
            else
              Navigator.pop(context);
          },
        ),
        title: Text(
          "task_text2".tr(),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height < 570 ? 18 : 22,
              color: colorPrimary),
        ),
        actions: [
          InkWell(
            onTap: () {
              _addProject();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 17, 10, 0),
              child: Text(
                "done_text".tr(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height < 570 ? 14 : 16,
                    color: colorPrimary),
              ),
            ),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          if (textTitle.text.length > 0 ||
              textDetails.text.length > 0 ||
              data != "") return onWillPop(size);
          return Future.value(true);
        },
        child: SingleChildScrollView(
          child: Center(
            child: Stack(
              children: [
                Column(
                  children: [
                    BlocListener<ProjectBloc, ProjectState>(
                      listener: (context, state) {
                        if (state is ProjectStateAddSuccessLoad) {
                          Navigator.pop(context);
                        } else if (state is ProjectStateAddFailLoad) {
                          setState(() {
                            loading = false;
                          });
                          util.showToast(
                            context: context,
                            msg: "Add Project Failed !",
                            color: colorError,
                            txtColor: colorBackground,
                            duration: 3,
                          );
                        }
                      },
                      child: Container(),
                    ),
                    SizedBox(height: 0.02 * size.height),
                    Container(
                        height: size.height <= 569 ? 80 : 100,
                        width: size.height <= 569 ? 80 : 100,
                        decoration: BoxDecoration(
                            color: colorNeutral170,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: data == "" ? BoxFit.none : BoxFit.fill,
                                image: data == ""
                                    ? AssetImage(
                                        "assets/images/photo-placeholder.png",
                                      )
                                    : FileImage(
                                        File(data),
                                      )))),
                    SizedBox(
                      height: 0.015 * size.height,
                    ),
                    InkWell(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Text(
                        "task_text3".tr(),
                        style: TextStyle(
                            fontSize: size.height < 570 ? 14 : 16,
                            color: colorPrimary),
                      ),
                    ),
                    /*_pictureValidator
                        ? Text(
                            "Please Choose a Picture as Your Group Picture",
                            style: TextStyle(color: colorError),
                          )
                        : Container(),*/
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _titleValidator
                                  ? colorError
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(5),
                          color: colorBackground,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                color: colorNeutral1,
                                blurRadius: 15),
                          ],
                        ),
                        child: TextFormField(
                          controller: textTitle,
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 3),
                              labelText: "Title",
                              labelStyle: TextStyle(
                                  fontSize: 14, color: colorNeutral2)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: _detailValidator
                                  ? colorError
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(5),
                          color: colorBackground,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 0),
                                color: colorNeutral1,
                                blurRadius: 15),
                          ],
                        ),
                        child: TextFormField(
                          controller: textDetails,
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 3),
                              labelText: "Short Description",
                              labelStyle: TextStyle(
                                  fontSize: 14, color: colorNeutral2)),
                        ),
                      ),
                    )
                  ],
                ),
                loading
                    ? Container(
                        width: size.width,
                        height: size.height,
                        color: Colors.black38.withOpacity(0.5),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 40),
                            child: CircularProgressIndicator(
                              backgroundColor: colorPrimary70,
                              // strokeWidth: 0,
                              valueColor:
                                  AlwaysStoppedAnimation(colorBackground),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _imagePicker() async {
    //ImagePicker for gallery

    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: maxHeight, maxWidth: maxWidth);

    if (pickedFile != null) {
      setState(() {
        data = pickedFile.path;
        print(data);
      });
    } else {}
  }

  _imagePickerCamera() async {
    //ImagePicker for Camera
    final pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: imageQualityCamera,
        maxHeight: maxHeight,
        maxWidth: maxWidth);

    if (pickedFile != null) {
      setState(() {
        data = pickedFile.path;
        print(data);
      });
    }
  }

  _addProject() {
    if (textTitle.text != "") {
      setState(() {
        _titleValidator = false;
      });
    } else {
      setState(() {
        _titleValidator = true;
      });
    }

    if (textDetails.text != "") {
      setState(() {
        _detailValidator = false;
      });
    } else {
      setState(() {
        _detailValidator = true;
      });
    }

    if (!_titleValidator && !_detailValidator) {
      setState(() {
        loading = true;
      });
      File image;
      if (data != null) {
        setState(() {
          image = File(data);
        });
      } else {
        setState(() {
          image = null;
        });
      }
      ProjectModel project = ProjectModel(
          name: textTitle.text.titleCase, details: textDetails.text);
      BlocProvider.of<ProjectBloc>(context)
          .add(AddProjectEvent(project, image));
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imagePicker();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imagePickerCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.cancel),
                    title: new Text('cancel_text'.tr()),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
