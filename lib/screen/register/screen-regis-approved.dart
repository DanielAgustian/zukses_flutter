import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zukses_app_1/bloc/bloc-core.dart';

import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/main.dart';
import 'package:zukses_app_1/model/register-model.dart';
import 'package:zukses_app_1/screen/register/screen-data-company.dart';
import 'package:zukses_app_1/tab/screen_tab.dart';
import 'package:zukses_app_1/util/util.dart';

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
                    "regis_success_text1".tr(),
                    style: TextStyle(
                        color: colorGoogle,
                        fontSize: size.height < 569 ? 18 : 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height < 569 ? 10 : 15,
                  ),
                  Text(
                    "regis_success_text2".tr(),
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
                      title: "exploring_text".tr(),
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
  bool visible = false;

  @override
  void initState() {
    super.initState();
    _timer();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        // print("MESSAGE ========================");
        // print(message.data);
        // notificationChecker(message);
      }
    });

    // handle click notif from foreground
    // Handle Click Notif from BackGround
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        // print("MESSAGE ========================");
        // print(message.data);
        // notificationChecker(message);
      }
    });

    // handle click notif from foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      AppleNotification ios = message.notification?.apple;
      if (notification != null && (android != null || ios != null)) {
        // print("MASUK ==========================================++>");
        // print(notification.body);
        flutterLocalNotificationsPlugin.initialize(
          initSetttings,
          onSelectNotification: (payload) {
            notificationChecker(message);
            return;
          },
        );
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                //icon: '@mipmap/traderindo_logo',
              ),
            ),
            payload: notification.body);
      }
    });
  }

  void _timer() {
    Timer(Duration(seconds: 1), () {
      _sentAcceptance();
    });
  }

  _sentAcceptance() {
    BlocProvider.of<RegisterBloc>(context).add(PostAcceptanceCompanyEvent());
  }

  void notificationChecker(RemoteMessage message) {
    //push to home if you have Accepted.
    if (message.notification.title
        .toLowerCase()
        .contains("company acceptance")) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ScreenTab()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: Visibility(
          visible: visible,
          child: FloatingActionButton(
            onPressed: _sentAcceptance,
            child: FaIcon(
              FontAwesomeIcons.redo,
              color: colorBackground,
            ),
          ),
        ),
        appBar: appBarOutside,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocListener<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        if (state is RegisterStateAccCompanyFailed) {
                          Util().showToast(
                              context: context,
                              msg: "PostAcceptance Failed",
                              duration: 3,
                              txtColor: colorBackground,
                              color: colorError);
                        }
                      },
                      child: Container()),
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
                    "setup_account_text8".tr(args: ["aforemonetioned company"]),
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
  PaymentApproved({Key key, this.title, this.token, this.paketID})
      : super(key: key);
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
                    "payment_text15".tr(),
                    style: TextStyle(
                        color: colorGoogle,
                        fontSize: size.height < 569 ? 18 : 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height < 569 ? 10 : 15,
                  ),
                  Text(
                    "payment_text17".tr(),
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
                      title: "payment_text16".tr(),
                      bgColor: colorPrimary,
                      textColor: colorBackground,
                      onClick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DataCompany(
                                    token: widget.token,
                                    paketID: widget.paketID)));
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
