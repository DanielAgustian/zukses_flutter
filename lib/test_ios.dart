import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:zukses_app_1/main.dart';
import 'package:zukses_app_1/util/util.dart';

class TestNotifIOS extends StatefulWidget {
  @override
  _TestNotifIOSState createState() => _TestNotifIOSState();
}

FirebaseMessaging messaging = FirebaseMessaging.instance;
// Crude counter to make messages unique
int _messageCount = 0;

/// The API endpoint here accepts a raw FCM payload for demonstration purposes.
String constructFCMPayload(String token) {
  _messageCount++;
  return jsonEncode({
    'token': token,
    "to": token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
  });
}

class _TestNotifIOSState extends State<TestNotifIOS> {
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

  // FOR NOTIFICATOIN =============================================
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

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // initDynamicLinks();
    // reqPermission();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print("MESSAGE ------------------------>");
        print(message.data);
        print(message.notification.title);
        print(message.notification.body);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      AppleNotification ios = message.notification.apple;

      if (notification != null && android != null) {
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
                icon: 'launch_background',
              ),
            ),
            payload: notification.body);
      } else if (notification != null && ios != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              iOS: IOSNotificationDetails(
                presentBadge: true,
                subtitle: "Test Notif IOS #1",
              ),
            ),
            payload: notification.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(message.data);
      print(message.messageId);
      print(message.senderId);
      print(message.sentTime);
    });
  }

  Future<void> sendPushMessage() async {
    if (tokenFCM == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(tokenFCM),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          print(
              'FlutterFire Messaging Example: Subscribing to topic "fcm_test".');
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          print(
              'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.');
        }
        break;
      case 'unsubscribe':
        {
          print(
              'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".');
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          print(
              'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.');
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            print('FlutterFire Messaging Example: Getting APNs token...');
            String token = await FirebaseMessaging.instance.getAPNSToken();
            print('FlutterFire Messaging Example: Got APNs token: $token');
            setState(() {
              tokenFCM = token;
            });
          } else {
            print('FlutterFire Messaging Example: Getting android token...');
            String token = await FirebaseMessaging.instance.getToken();
            setState(() {
              tokenFCM = token;
            });
            print('FlutterFire Messaging Example: Got android token: $token');
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Messaging'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: onActionSelected,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'subscribe',
                  child: Text('Subscribe to topic'),
                ),
                const PopupMenuItem(
                  value: 'unsubscribe',
                  child: Text('Unsubscribe to topic'),
                ),
                const PopupMenuItem(
                  value: 'get_apns_token',
                  child: Text('Get APNs token (Apple only)'),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: sendPushMessage,
          backgroundColor: Colors.white,
          child: const Icon(Icons.send),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // MetaCard('Permissions', Permissions()),
          // MetaCard('FCM Token', TokenMonitor((token) {
          //   _token = token;
          //   return token == null
          //       ? const CircularProgressIndicator()
          //       : Text(token, style: const TextStyle(fontSize: 12));
          // })),
          MetaCard('$tokenFCM', Container()),
          MetaCard('Message Stream', MessageList()),
        ]),
      ),
    );
  }
}

/// UI Widget for displaying metadata.
class MetaCard extends StatelessWidget {
  final String _title;
  final Widget _children;

  // ignore: public_member_api_docs
  MetaCard(this._title, this._children);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child:
                          Text(_title, style: const TextStyle(fontSize: 18))),
                  _children,
                ]))));
  }
}

/// Listens for incoming foreground messages and displays them in a list.
class MessageList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MessageList();
}

class _MessageList extends State<MessageList> {
  List<RemoteMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _messages = [..._messages, message];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_messages.isEmpty) {
      return const Text('No messages received');
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          RemoteMessage message = _messages[index];

          return ListTile(
            title: Text(
                message.messageId ?? 'no RemoteMessage.messageId available'),
            subtitle:
                Text(message.sentTime?.toString() ?? DateTime.now().toString()),
          );
        });
  }
}

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SafeArea(
//           child: Column(
//         children: [
//           Text("$msgLink"),
//           LongButton(
//             size: size,
//             bgColor: colorGoogle,
//             textColor: colorBackground,
//             title: "TEST NOTIF IOS",
//             onClick: () {
//               createFirebaseDynamicLink(true);
//             },
//           )
//         ],
//       )),
//     );
//   }
// }
