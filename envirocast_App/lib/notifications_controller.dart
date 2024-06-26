import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:envirocast/screens/air_condition_screen.dart';
import 'package:flutter/material.dart';

class NotificationsController {
  static bool notificationDisplayed = false;
  static List<int?> activeNotifications = [];
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreateMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    activeNotifications.add(receivedNotification.id);
    notificationDisplayed = true;
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationReceivedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    activeNotifications.remove(receivedNotification.id);
    DateTime now = DateTime.now();
    DateTime morning = DateTime(now.year, now.month, now.day, 6, 0, 0);
    DateTime afternoon = DateTime(now.year, now.month, now.day, 12, 0, 0);
    DateTime evening = DateTime(now.year, now.month, now.day, 18, 0, 0);
    Color colorUp;
    Color colorDown;
    if (now.isAfter(morning) && now.isBefore(afternoon)) {
      colorUp = Colors.yellow;
      colorDown = Colors.blue;
    } else if (now.isAfter(afternoon) && now.isBefore(evening)) {
      colorUp = Colors.orange;
      colorDown = Colors.purple;
    } else {
      colorUp = Colors.blue;
      colorDown = Colors.deepPurple;
    }
    MaterialPageRoute(
        builder: (context) => AirConditionScreen(
              colorUp: colorUp,
              colorDown: colorDown,
            ));
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    activeNotifications.remove(receivedNotification.id);
  }
}
