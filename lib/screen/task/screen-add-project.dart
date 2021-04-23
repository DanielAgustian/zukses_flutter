import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/bloc/bussiness-scope/business-scope-bloc.dart';
import 'package:zukses_app_1/bloc/project/project-bloc.dart';
import 'package:zukses_app_1/bloc/project/project-event.dart';
import 'package:zukses_app_1/bloc/project/project-state.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/project-model.dart';
import 'package:zukses_app_1/util/util.dart';
import 'package:recase/recase.dart';

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
          icon: Icon(Icons.arrow_back, color: colorPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Add Project",
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
                "Done",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height < 570 ? 14 : 16,
                    color: colorPrimary),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
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
                      height: size.height <= 569 ? 100 : 150,
                      width: size.height <= 569 ? 100 : 150,
                      decoration: BoxDecoration(
                          color: colorPrimary,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: data == ""
                                  ? AssetImage("assets/images/ava.png")
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
                      "Change Icon",
                      style: TextStyle(
                          fontSize: size.height < 570 ? 14 : 16,
                          color: colorPrimary),
                    ),
                  ),
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
                            labelText: 'Title',
                            labelStyle:
                                TextStyle(fontSize: 14, color: colorNeutral2)),
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
                            labelText: 'Key Value',
                            labelStyle:
                                TextStyle(fontSize: 14, color: colorNeutral2)),
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
                            valueColor: AlwaysStoppedAnimation(colorBackground),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  _imagePicker() async {
    //ImagePicker for gallery

    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        data = pickedFile.path;
        print(data);
      });
    } else {}
  }

  _imagePickerCamera() async {
    //ImagePicker for Camera
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 85);

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
      }
      ProjectModel project =
          ProjectModel(name: textTitle.text.titleCase, details: textDetails.text);
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
                    title: new Text('Cancel'),
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
