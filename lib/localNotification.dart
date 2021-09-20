import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notify1/notification/LocalNotification.dart';

class PushNotificationService {
  LocalNotifications _notification = LocalNotifications();
  PushNotificationMessage notification;
  final FirebaseMessaging _fcm;
  final BuildContext context;
  PushNotificationService(this._fcm, this.context);
  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _notification.initializing();
        _notification.notification(
            message["notification"]['title'], message["notification"]["body"]);
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Notification"),
              actions: [
                Text(message["notification"]['title']),
                Text(message["notification"]["body"]),
              ],
            );
          },
        );
        // if (Platform.isAndroid) {
        //   notification = PushNotificationMessage(
        //     title: message['notification']['title'],
        //     body: message['notification']['body'],
        //   );

        // }
        // showSimpleNotification(
        //   Container(child: Text(notification.body)),
        //   position: NotificationPosition.top,
        // );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _notification.initializing();
        _notification.notification(
            message["notification"]['title'], message["notification"]["body"]);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _notification.initializing();
        _notification.notification(
            message["notification"]['title'], message["notification"]["body"]);
      },
    );
  }
}

class PushNotificationMessage {
  final String title;
  final String body;
  PushNotificationMessage({
    @required this.title,
    @required this.body,
  });
}
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotifications {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   AndroidInitializationSettings androidInitializationSettings;
//   IOSInitializationSettings iosInitializationSettings;
//   InitializationSettings initializationSettings;
//
//   void initializing() async {
//     androidInitializationSettings = AndroidInitializationSettings('app_icon');
//     iosInitializationSettings = IOSInitializationSettings(
//         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//     initializationSettings = InitializationSettings(
//         androidInitializationSettings, iosInitializationSettings);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//   }
//
//   Future<void> notification(String title, String message) async {
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             'Channel ID', 'Channel title', 'channel body',
//             priority: Priority.Default,
//             importance: Importance.Default,
//             ticker: 'test');
//
//     IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
//
//     NotificationDetails notificationDetails =
//         NotificationDetails(androidNotificationDetails, iosNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(
//         0, title, message, notificationDetails);
//   }
//
//   Future<void> notificationAfterSec() async {
//     var timeDelayed = DateTime.now().add(Duration(seconds: 5));
//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             'second channel ID', 'second Channel title', 'second channel body',
//             priority: Priority.Default,
//             importance: Importance.Default,
//             ticker: 'test');
//
//     IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
//
//     NotificationDetails notificationDetails =
//         NotificationDetails(androidNotificationDetails, iosNotificationDetails);
//     await flutterLocalNotificationsPlugin.schedule(1, 'Hello there',
//         'please subscribe my channel', timeDelayed, notificationDetails);
//   }
//
//   Future onSelectNotification(String payLoad) {
//     if (payLoad != null) {
//       print(payLoad);
//     }
//
//     // we can set navigator to navigate another screen
//   }
//
//   Future onDidReceiveLocalNotification(
//       int id, String title, String body, String payload) async {
//     return CupertinoAlertDialog(
//       title: Text(title),
//       content: Text(body),
//       actions: <Widget>[
//         CupertinoDialogAction(
//             isDefaultAction: true,
//             onPressed: () {
//               print("");
//             },
//             child: Text("Okay")),
//       ],
//     );
//   }
// }
