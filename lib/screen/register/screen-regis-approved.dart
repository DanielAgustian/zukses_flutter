import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/model/register-model.dart';
import 'package:zukses_app_1/screen/register/screen-data-company.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';

class RegisApproved extends StatefulWidget {
  RegisApproved({Key key, this.title, this.register}) : super(key: key);
  final String title;
  final RegisterModel register;
  @override
  _RegisApprovedScreen createState() => _RegisApprovedScreen();
}

/// This is the stateless widget that the main application instantiates.
class _RegisApprovedScreen extends State<RegisApproved> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBarOutside,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: size.height < 569 ? 100 : 120,
                    height: size.height < 569 ? 100 : 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: colorNeutral2),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: size.height < 569 ? 60 : 100,
                        height: size.height < 569 ? 60 : 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: colorPrimary),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            size: size.height < 569 ? 42 : 52,
                            color: colorBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height < 569 ? 15 : 25,
                  ),
                  Text(
                    "Registration Success",
                    style: TextStyle(
                        color: colorGoogle,
                        fontSize: size.height < 569 ? 18 : 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height < 569 ? 10 : 15,
                  ),
                  Text(
                    "You have successfully created account!",
                    style: TextStyle(
                      color: colorGoogle,
                      fontSize: size.height < 569 ? 12 : 14,
                    ),
                  ),
                  SizedBox(
                    height: 0.1 * size.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: LongButton(
                      size: size,
                      title: "Start Exploring",
                      bgColor: colorPrimary,
                      textColor: colorBackground,
                      onClick: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenTab()),
                            (Route<dynamic> route) => false);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class WaitRegisApproved extends StatefulWidget {
  WaitRegisApproved({Key key, this.title, this.company}) : super(key: key);
  final String title;
  final String company;
  @override
  _WaitRegisApprovedScreen createState() => _WaitRegisApprovedScreen();
}

/// This is the stateless widget that the main application instantiates.
class _WaitRegisApprovedScreen extends State<WaitRegisApproved> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBarOutside,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: size.height < 569 ? 100 : 120,
                    height: size.height < 569 ? 100 : 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: colorNeutral2),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: size.height < 569 ? 60 : 100,
                        height: size.height < 569 ? 60 : 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: colorPrimary),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            size: size.height < 569 ? 42 : 52,
                            color: colorBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height < 569 ? 15 : 25,
                  ),
                  Text(
                    "Waiting for Approval",
                    style: TextStyle(
                        color: colorGoogle,
                        fontSize: size.height < 569 ? 18 : 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height < 569 ? 10 : 15,
                  ),
                  Text(
                    "Your request has been sent to PT. ${widget.company}. You will be notify by email when admin already accept your request and redirected to the dashboard.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorGoogle,
                      fontSize: size.height < 569 ? 12 : 14,
                    ),
                  ),
                  SizedBox(
                    height: 0.1 * size.width,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class PaymentApproved extends StatefulWidget {
  PaymentApproved({Key key, this.title, this.token, this.paketID}) : super(key: key);
  final String title;
  final String token;
  final String paketID;
  @override
  _PaymentApprovedScreen createState() => _PaymentApprovedScreen();
}

/// This is the stateless widget that the main application instantiates.
class _PaymentApprovedScreen extends State<PaymentApproved> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBarOutside,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: size.height < 569 ? 100 : 120,
                    height: size.height < 569 ? 100 : 120,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: colorNeutral2),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: size.height < 569 ? 60 : 100,
                        height: size.height < 569 ? 60 : 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: colorPrimary),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.check,
                            size: size.height < 569 ? 42 : 52,
                            color: colorBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height < 569 ? 15 : 25,
                  ),
                  Text(
                    "Payment Complete",
                    style: TextStyle(
                        color: colorGoogle,
                        fontSize: size.height < 569 ? 18 : 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height < 569 ? 10 : 15,
                  ),
                  Text(
                    "Thank you, your payment has been successful. A confirmation email and receipt has been sent to yourcompany@gmail.com.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorGoogle,
                      fontSize: size.height < 569 ? 12 : 14,
                    ),
                  ),
                  SizedBox(
                    height: 0.1 * size.width,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: LongButton(
                      size: size,
                      title: "Continue to Company Data",
                      bgColor: colorPrimary,
                      textColor: colorBackground,
                      onClick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DataCompany(token: widget.token, paketID: widget.paketID)));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
