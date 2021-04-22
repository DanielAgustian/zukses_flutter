import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zukses_app_1/component/user-profile/text-format.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/user-model.dart';
import 'package:zukses_app_1/screen/profile/user-settings.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key, this.title, this.user}) : super(key: key);
  final String title;

  final UserModel user;
  @override
  _EditProfileScreen createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<EditProfile> {
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                padding: EdgeInsets.only(right: paddingHorizontal),
                child: Text("Done",
                    style: TextStyle(
                        fontSize: size.height <= 569 ? 15 : 18,
                        color: colorPrimary,
                        fontWeight: FontWeight.bold)),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserSettings()));
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Layout for Edit Profile here.
              Center(
                child: Stack(
                  children: [
                    Padding(
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
                          )),
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
                              child: FaIcon(FontAwesomeIcons.pencilAlt,
                                  color: colorBackground,
                                  size: size.height < 569 ? 12 : 14),
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
                        bottom:
                            BorderSide(width: 3, color: Color(0xFFF4F4F4)))),
                child: Text(
                  "Personal Information",
                  style: TextStyle(
                      color: colorPrimary,
                      fontSize: size.height < 569 ? 14 : 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextFormat1(
                size: size,
                title: "Name",
                data: widget.user.name,
              ),
              TextFormat1(
                  size: size,
                  title: "Username",
                  data: widget.user.email //"Harus Diisi ",
                  ),
              TextFormat1(
                size: size,
                title: "Zukses ID",
                data: widget.user.userID,
              ),
              TextFormat1(
                size: size,
                title: "Phone Number",
                data: widget.user.phone == null
                    ? "Not Registered"
                    : widget.user.phone,
              ),
              TextFormat1(
                size: size,
                title: "Personal Email",
                data: widget.user.email,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _imagePicker(int index) async {
    if (index == 0) {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          String data = pickedFile.path;
        });
        //Camera
      }
    } else if (index == 1) {
      //Gallery
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          String data = pickedFile.path;
        });
      }
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
