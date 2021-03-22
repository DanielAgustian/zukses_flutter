import 'package:flutter/material.dart';
import 'package:zukses_app_1/constant/constant.dart';

class AddProject extends StatefulWidget {
  AddProject({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AddProjectScreen createState() => _AddProjectScreen();
}

/// This is the stateless widget that the main application instantiates.
class _AddProjectScreen extends State<AddProject> {
  TextEditingController _textTitle = TextEditingController();
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
              fontSize: size.height < 570 ? 22 : 25,
              color: colorPrimary),
        ),
        actions: [
          InkWell(
            onTap: () {},
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
          child: Column(
            children: [
              SizedBox(height: 0.02 * size.height),
              Container(
                  height: size.height <= 569 ? 100 : 150,
                  width: size.height <= 569 ? 100 : 150,
                  decoration: BoxDecoration(
                      color: colorPrimary,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: Image.asset("assets/images/ava.png").image))),
              SizedBox(
                height: 0.015 * size.height,
              ),
              Text(
                "Change Icon",
                style: TextStyle(
                    fontSize: size.height < 570 ? 14 : 16, color: colorPrimary),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
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
                padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Container(
                  decoration: BoxDecoration(
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
        ),
      ),
    );
  }
}
