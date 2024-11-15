import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Import for handling local notifications
import 'dart:io' show Platform; // Import to detect the platform (iOS or Android)
import 'package:permission_handler/permission_handler.dart';  // Import to request permissions (Android 13+)
import 'SellPost.dart';
import 'snackbar_helper.dart';
import 'MainPage.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class Notifications{
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Define Android-specific settings (using app icon for notifications)
  final AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // Combine Android-specific initialization settings
  late final InitializationSettings initializationSettings;

  Notifications() {
    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Initialize the plugin with the settings
    _initializeNotifications();
  }


  Future<void> _initializeNotifications() async {
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Request notification permission (for Android 13+)
    if (Platform.isAndroid)
      await _requestPermissions();
  }
  Future<void> _onDidReceiveNotificationResponse(NotificationResponse response) async {
    if (response.payload != null){
      final context = navigatorKey.currentContext;

      if (context != null) {
        // Use Navigator to push the specific page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Main(), // Pass the postId
          ),
        );
      }
    }

  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      // Optionally show a dialog explaining why notifications are needed
      await Permission.notification.request();
    }


    if (await Permission.notification.isDenied) {
      print("Permission Denied");

    }
  }

  Future<void> sendAddListingNotification(SellPost post) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'add_listing_channel', // Channel ID
      'Add Listing Notifications', // Channel name
      channelDescription: 'Notifications for new listings added',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'New Listing Added', // Notification title
      'Listing: ${post.model}  ${post.price}', // Notification body with post title
      platformChannelSpecifics,
    );
  }


}