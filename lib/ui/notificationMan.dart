import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:buzz/ui/inChannel.dart';

class BuzzNotification {
  BuildContext context;
  String channelID;
  BuzzNotification({this.context, this.channelID});

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  void setUpNotification() {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: (x, y, z, w) {});
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    debugPrint('bz: initialized');
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (context) => InChannel(
                channelID: channelID,
              )),
    );
  }

  void addNotification(String courseCode, Time tm, Day day, int id) {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        courseCode + 'at' + tm.toString(),
        'Weekly alerts' + courseCode + 'at' + tm.toString(),
        'Weekly reminder for $courseCode' + courseCode + 'at' + tm.toString(),
        );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(id, '$courseCode',
        'Class starts in an Hour', day, tm, platformChannelSpecifics);
    debugPrint(
        'go off time is ${tm.hour.toString()} : ${tm.minute.toString()}');
    debugPrint('notification added id: ${id.toString()}');
  }
}
