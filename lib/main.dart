import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:notify1/localNotification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:notify1/newscreen.dart';

// import 'message.dart';
// import 'message_list.dart';
// import 'permissions.dart';
// import 'token_monitor.dart';

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Notification'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // LocalNotifications sendnotify=LocalNotifications();
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  dynamic data;
  TextEditingController controller = TextEditingController();
  var tokin;
  var sendertokin;
  @override
  void initState() {
    super.initState();

    settokin();
    gettokin();
  }

  @override
  Widget build(BuildContext context) {
    final pushNotificationService =
        PushNotificationService(_firebaseMessaging, context);
    pushNotificationService.initialise();
    // FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              autofocus: false,
              controller: controller,
              decoration: InputDecoration(
                hintText: "Message",
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (controller != null)
                    _sendAndRetrieveMessage(controller.text, sendertokin);
                },
                child: Text("Send")),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => newscreen(),
            //           ));
            //     },
            //     child: Text("Go New Screen"))
          ],
        ),
      ),
    );
  }

  void settokin() async {
    await _firebaseMessaging.getToken().then((value) {
      setState(() {
        tokin = value;
      });
    });
    final DocumentReference document =
        Firestore.instance.collection("users").document("user2");
    await document.setData({
      "tokin": tokin,
    });
  }

  void gettokin() async {
    final DocumentReference document =
        Firestore.instance.collection("users").document("user1");
    document.get().then((value) {
      setState(() {
        sendertokin = value.data["tokin"];
      });
    });
  }

  Future<void> _sendAndRetrieveMessage(String message, String tokin) async {
    // Go to Firebase console -> Project settings -> Cloud Messaging -> copy Server key
    // the Server key will start "AAAAMEjC64Y..."

    final yourServerKey =
        "AAAAd3jCLos:APA91bE4zHhiPUenMkbqHNsWQgoRn64j0mF97o52DD4DPIKujcHvtObxQSXnLdsqF-6K21aHKl_BHpsBy5rdFxIjnaQBvzwwBjcIjxwDvl3gGFGYh8rZQsHTQy9N5alx61-IuZ9zrGNr";
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$yourServerKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': message,
            'title': 'Message',
            'image':
                'https://yt3.ggpht.com/ytc/AAUvwnjuH8xEOYQyRAE2NMrVieRw0GBbcJ9l5wLPpvgHDQ=s88-c-k-c0x00ffffff-no-rj'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          // FCM Token lists.
          // 'registration_ids': ["Your_FCM_Token_One", "Your_FCM_Token_Two"],
          'to': tokin
        },
      ),
    );
  }
}
