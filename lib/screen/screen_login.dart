import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:zukses_app_1/screen/screen_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';

class ScreenLogin extends StatefulWidget {
  ScreenLogin({Key key, this.title}) : super(key: key);
 
  final String title;

  @override
  _ScreenLogin createState() => _ScreenLogin();
}

class _ScreenLogin extends State<ScreenLogin> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) { 
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Zukses"),
        ),
        body: SingleChildScrollView(
            child: Container(
                alignment: Alignment.topCenter,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "ZUKSES",
                        style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Color.fromRGBO(20, 43, 111, 0.9),
                                letterSpacing: 1.5),
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 40),
                      SizedBox(
                        width: 250,
                        child: RaisedButton(
                          padding: const EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScreenLogin()),
                            );
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('icon/google_icon.png'),
                                SizedBox(width: 10),
                                Text(
                                  "Sign in with Google",
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                    fontSize: 16,
                                  )),
                                )
                              ]),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: RaisedButton(
                            padding: const EdgeInsets.all(8.0),
                            textColor: Colors.white,
                            color: Color.fromRGBO(20, 43, 111, 0.9),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScreenLogin()),
                              );
                            },
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('icon/facebook_icon.png'),
                                SizedBox(width: 20),
                                new Text(
                                  "Sign in with Facebook",
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                    fontSize: 16,
                                  )),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "OR",
                        style: GoogleFonts.lato(
                            textStyle:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 18),
                          decoration: InputDecoration(
                            hintText: 'Username',
                            labelStyle: TextStyle(color: Colors.black54),
                            hintStyle: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                        child: TextFormField(
                          //controller: textPassword,
                          cursorColor: Colors.blue,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 18),
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              // _passValidator == '' ? null : _passValidator,
                              labelStyle: TextStyle(color: Colors.black54),
                              hintStyle: TextStyle(color: Colors.black54),
                              focusColor: Colors.black,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black54),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              suffixIcon: IconButton(
                                icon: FaIcon(
                                  _obscureText
                                      ? FontAwesomeIcons.solidEye
                                      : FontAwesomeIcons.eye,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              )),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(30, 10, 40, 0),
                              child: Text(
                                "Forgot Password?",
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(20, 43, 111, 0.9),
                                    ),
                                    fontWeight: FontWeight.bold),
                              ))),
                      SizedBox(height: 40),
                      SizedBox(
                        width: 250,
                        child: RaisedButton(
                          padding: const EdgeInsets.all(8.0),
                          textColor: Colors.white,
                          color: Color.fromRGBO(20, 43, 111, 0.9),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScreenTab()),
                            );
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: new Text(
                            "Login",
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                              fontSize: 16,
                            )),
                          ),
                        ),
                      ),
                    ]))));
  }
}
