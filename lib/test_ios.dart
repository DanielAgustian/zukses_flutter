import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/button/button-long.dart';
import 'package:zukses_app_1/constant/constant.dart';
import 'package:zukses_app_1/util/util.dart';

class TestNotifIOS extends StatefulWidget {
  @override
  _TestNotifIOSState createState() => _TestNotifIOSState();
}

FirebaseMessaging messaging = FirebaseMessaging.instance;

class _TestNotifIOSState extends State<TestNotifIOS> {
  String tokenFCM;

  void _getTokenFCM() async {
    var token = await Util().getTokenFCM();
    setState(() {
      tokenFCM = token;
    });

    print("TOKEN APNS $tokenFCM");
  }

  NotificationSettings setting;

  void reqPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    setState(() {
      setting = settings;
    });

    if (setting.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (setting.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
  }

  // MAKE DYNAMIC LINK FIREBASE
  bool isCreateLink = false;
  String msgLink;

  Future createFirebaseDynamicLink(bool short) async {
    setState(() {
      isCreateLink = true;
    });
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://zuksesapplication.page.link',
      link: Uri.parse('https://zuksesapplication/welcome?userId=1'),
      iosParameters: IosParameters(
          bundleId: 'com.yokesen.zuksesapp', appStoreId: '1570075964'),
      // dynamicLinkParametersOptions: DynamicLinkParametersOptions(
      //     shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //   title: 'SOCIAL MEDIA DEEPLINK',
      //   description: 'Just try it, apakah jalan atau ga',
      // ),
    );
    print("DONE CONFIG $short");
    Uri url;
    // if (short) {
    //   // make short url
    //   print("Creating short . . . ");
    ShortDynamicLink shortLink = await parameters.buildShortLink();
    url = shortLink.shortUrl;
    // } else {
    // make long url
    // url = await parameters.buildUrl();
    // }

    print(url);

    setState(() {
      msgLink = "Hey guys !, checkout my signal info here ${url.toString()}";
      isCreateLink = false;
    });
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        final queryParams = deepLink.queryParameters;

        print("===================++> $queryParams");
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      final queryParams = deepLink.queryParameters;

      print("via get initial link ===================++> $queryParams");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    reqPermission();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage?.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat',
    //       arguments: ChatArguments(initialMessage));
    // }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   if (message.data['type'] == 'chat') {
    //     print(message.data);
    //     print(message.senderId);
    //     print(message.sentTime);
    //     print(message.data["title"]);
    //   }
    // });
    initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Text("$msgLink"),
          LongButton(
            size: size,
            bgColor: colorGoogle,
            textColor: colorBackground,
            title: "TEST NOTIF IOS",
            onClick: () {
              createFirebaseDynamicLink(true);
            },
          )
        ],
      )),
    );
  }
}
