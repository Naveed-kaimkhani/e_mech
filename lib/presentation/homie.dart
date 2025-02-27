import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/notification_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Notifications'),
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              // send notification from one device to another
              notificationServices.getDeviceToken().then((value) async {
                var data = {
                  'to': value.toString(),
                  'notification': {
                    'title': 'Asif',
                    'body': 'Subscribe to my channel',
                    // "sound": "jetsons_doorbell.mp3"
                  },
                  'android': {
                    'notification': {
                      'notification_count': 23,
                    },
                  },
                  'data': {'type': 'msj', 'id': 'Asif Taj'}
                };

                await http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization':
                          'key=AAAAxDHbazE:APA91bEK6_7-USKl15JqE4bH_ZZUrMHGCZTr1QCAT-WYJGPo3eTcAaLco3769dxP-GINLskhZOwz2KmddEL8VCGPERQBFUgysXEKTt2TNd49z2qqw6zd98oncZcTbrPpbgLe20Opw0Nb'
                    }).then((value) {
                  if (kDebugMode) {
                    print(value.body.toString());
                  }
                }).onError((error, stackTrace) {
                  if (kDebugMode) {
                    print(error);
                  }
                });
              });
            },
            child: Text('Send Notifications')),
      ),
    );
  }
}
