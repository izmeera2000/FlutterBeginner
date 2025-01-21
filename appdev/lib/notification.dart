import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  await initializeNotifications();
  runApp(MyApp());
}

// Request notification and exact alarm permissions
Future<void> requestPermissions() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  if (await Permission.scheduleExactAlarm.isDenied) {
    // Notify the user to manually enable this permission
    print("Go to settings and enable 'SCHEDULE EXACT ALARM' manually.");
  }
}

// Initialize notifications
Future<void> initializeNotifications() async {
  tz.initializeTimeZones();

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("Notification Tapped: ${response.payload}");
    },
  );
}

// Show immediate notification
Future<void> showNotification() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'instant_channel',
    'Instant Notifications',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Test Notification',
    'This is an instant notification!',
    details,
    payload: 'Instant Notification Payload',
  );
}

// Schedule notification (Android 12+ support)
Future<void> scheduleNotification() async {
  await requestPermissions(); // Ensure permissions are granted

  await flutterLocalNotificationsPlugin.zonedSchedule(
    1, // Notification ID
    'Scheduled Notification',
    'This will appear after 5 seconds!',
    tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)), // Delay of 5s
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel_id',
        'Scheduled Notifications',
        channelDescription: 'Notifications that are scheduled',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Required for scheduling
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

// Main UI
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Notifications")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: showNotification,
              child: Text("Show Instant Notification"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: scheduleNotification,
              child: Text("Schedule Notification (5s)"),
            ),
          ],
        ),
      ),
    );
  }
}
