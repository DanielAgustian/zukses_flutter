import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-bloc.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-event.dart';
import 'package:zukses_app_1/bloc/user-data/user-data-state.dart';
import 'package:zukses_app_1/component/user-profile/text-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/util/util.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key, this.title, this.user}) : super(key: key);
  final String title;

  final UserModel user;
  @override
  _EditProfileScreen createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<EditProfile> {
  final picker = ImagePicker();
  final textEditName = TextEditingController();
  final textEditPhone = TextEditingController();
  //bool data = false;
  bool uploading = false;
  String data = "";
  UserModel userModel = UserModel();
  bool allowDelete = false;

  _editData() {
    if (data != null && data != "") {
      //Edit Profile with Profile Pic Changes
      BlocProvider.of<UserDataBloc>(context).add(UserDataUpdateProfileEvent(
        textEditName.text,
        textEditPhone.text,
        image: File(data),
      ));
    } else {
      if (userModel.imgUrl == null || userModel.imgUrl == "" || allowDelete) {
        //Edit Profile without any Picture
        BlocProvider.of<UserDataBloc>(context).add(
            UserDataUpdateProfileEvent(textEditName.text, textEditPhone.text));
      } else {
        //Edit Profile with Old Picture inside DB
        BlocProvider.of<UserDataBloc>(context).add(UserDataUpdateProfileEvent(
            textEditName.text, textEditPhone.text,
            link: userModel.imgUrl));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    userModel = widget.user;
    textEditName.text = userModel.name;
    if (userModel.phone == null || userModel.phone == "") {
      textEditPhone.text = "";
    } else {
      textEditPhone.text = userModel.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBackground,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: colorPrimary,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height < 570 ? 18 : 22,
              color: colorPrimary),
        ),
        actions: [
          InkWell(
              child: Container(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text("Done",
                        style: TextStyle(
                            fontSize: size.height <= 569 ? 15 : 18,
                            color: colorPrimary,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              onTap: () {
                _editData();
                /*Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserSettings()));*/
              })
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocListener<UserDataBloc, UserDataState>(
                    listener: (context, state) {
                      if (state is UserDataStateUpdateSuccess) {
                        setState(() {
                          uploading = false;
                        });
                        Navigator.pop(context);
                      } else if (state is UserDataStateUpdateFail) {
                        setState(() {
                          uploading = false;
                        });
                        Util().showToast(
                            duration: 3,
                            context: context,
                            msg: "Update Data Wrong",
                            color: colorError,
                            txtColor: colorBackground);
                      } else if (state is UserDataStateLoading) {
                        setState(() {
                          uploading = true;
                        });
                      }
                    },
                    child: Container(),
                  ),
                  //Layout for Edit Profile here.
                  Center(
                    child: Stack(
                      children: [
                        allowDelete
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: Container(
                                    width: size.height < 569 ? 75 : 90,
                                    height: size.height < 569 ? 75 : 90,
                                    decoration: BoxDecoration(
                                      color: colorNeutral2,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.camera,
                                        color: colorNeutral3,
                                      ),
                                    )))
                            : Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                child: (widget.user.imgUrl == "" ||
                                            widget.user.imgUrl == null) &&
                                        (data == null || data == "")
                                    ? Container(
                                        width: size.height < 569 ? 75 : 90,
                                        height: size.height < 569 ? 75 : 90,
                                        decoration: BoxDecoration(
                                          color: colorNeutral2,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.camera,
                                            color: colorNeutral3,
                                          ),
                                        ))
                                    : Container(
                                        width: size.height < 569 ? 75 : 90,
                                        height: size.height < 569 ? 75 : 90,
                                        decoration: BoxDecoration(
                                            color: colorNeutral2,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                image: data != ""
                                                    ? FileImage(File(data))
                                                    : NetworkImage(
                                                        "https://api-zukses.yokesen.com/${widget.user.imgUrl}"))),
                                      ),
                              ),
                        Positioned(
                            right: 0.0,
                            bottom: 0.0,
                            child: InkWell(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: Container(
                                width: size.height < 569 ? 28 : 32,
                                height: size.height < 569 ? 28 : 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: FaIcon(FontAwesomeIcons.image,
                                      color: colorBackground,
                                      size: size.height < 569 ? 16 : 18),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.height < 569 ? 10 : 15,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.user.name,
                          style: TextStyle(
                              color: colorPrimary,
                              fontSize: size.height < 569 ? 16 : 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("Personal",
                            style: TextStyle(
                                color: colorPrimary,
                                fontSize: size.height < 569 ? 14 : 16))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height < 569 ? 10 : 15,
                  ),
                  Container(
                    width: size.width,
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 3, color: Color(0xFFF4F4F4)))),
                    child: Text(
                      "Personal Information",
                      style: TextStyle(
                          color: colorPrimary,
                          fontSize: size.height < 569 ? 14 : 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormatEdit(
                    textEdit: textEditName,
                    size: size,
                    title: "Name",
                    onChanged: (val) {},
                  ),
                  TextFormat1(
                      txtColor: colorPrimary70,
                      size: size,
                      title: "Username",
                      data: widget.user.email //"Harus Diisi ",
                      ),
                  TextFormat1(
                    txtColor: colorPrimary70,
                    size: size,
                    title: "Zukses ID",
                    data: widget.user.userID,
                  ),
                  TextFormatEdit(
                    size: size,
                    title: "Phone Number",
                    textEdit: textEditPhone,
                    onChanged: (val) {},
                  ),
                  TextFormat1(
                    txtColor: colorPrimary70,
                    size: size,
                    title: "Personal Email",
                    data: widget.user.email,
                  ),
                ],
              ),
            ),
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
    );
  }

  _imagePicker(int index) async {
    if (index == 0) {
      final pickedFile = await picker.getImage(
          source: ImageSource.gallery,
          maxWidth: maxWidth,
          maxHeight: maxHeight);

      if (pickedFile != null) {
        setState(() {
          data = pickedFile.path;
        });
        //Camera

      }
    } else if (index == 1) {
      //Gallery
      final pickedFile = await picker.getImage(
          source: ImageSource.camera, maxWidth: maxWidth, maxHeight: maxHeight);
      if (pickedFile != null) {
        setState(() {
          data = pickedFile.path;
        });
      }
    }
    print(data);
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
                        _imagePicker(0);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imagePicker(1);
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                      leading: new FaIcon(FontAwesomeIcons.eyeSlash),
                      title: new Text('Empty Picture'),
                      onTap: () {
                        setState(() {
                          allowDelete = true;
                        });
                        Navigator.of(context).pop();
                      }),
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
