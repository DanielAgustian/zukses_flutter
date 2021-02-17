import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zukses_app_1/second_click.dart';
import 'package:zukses_app_1/third_click.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
                      SizedBox(height: 50),
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(20, 43, 111, 0.9),
                            shape: BoxShape.circle),
                      ),
                      SizedBox(height: 30),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(40, 1, 40, 0),
                              child: Text(
                                "Lorem Pisum",
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromRGBO(
                                            135, 147, 181, 0.9))),
                              ))),
                      Padding(
                          padding: EdgeInsets.fromLTRB(40, 1, 40, 0),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque quis facilisis neque. Aliquam ',
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(20, 43, 111, 0.9))),
                          )),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              color: Color.fromRGBO(20, 43, 111, 0.9),
                              width: 10.0,
                              height: 10.0,
                            ),
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              color: Color.fromRGBO(128, 128, 128, 0.9),
                              width: 7.0,
                              height: 7.0,
                            ),
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              color: Color.fromRGBO(128, 128, 128, 0.9),
                              width: 7.0,
                              height: 7.0,
                            ),
                          ]),
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ThirdPage()),
                          );
                        },
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 1, 40, 0),
                                child: Text(
                                  "Skip",
                                  style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromRGBO(
                                              135, 147, 181, 0.9))),
                                ))),
                      ),
                      SizedBox(height: 10),
                      RawMaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SecondPage()),
                          );
                        },
                        elevation: 2.0,
                        fillColor: Color.fromRGBO(20, 43, 111, 0.9),
                        child: Icon(Icons.arrow_forward,
                            size: 35.0, color: Colors.white70),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      )
                    ]))));
  }
}
