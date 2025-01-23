import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VibrateExample(),
    );
  }
}

class VibrateExample extends StatelessWidget {
  Future<void> vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500); // Vibrate for 500ms
    }
  }

  Future<void> vibratePattern() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [500, 1000, 500, 2000]); 
      // Vibrate for 500ms, pause 1000ms, vibrate 500ms, pause 2000ms
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Vibrate Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: vibrate,
              child: Text("Vibrate"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: vibratePattern,
              child: Text("Vibrate Pattern"),
            ),
          ],
        ),
      ),
    );
  }
}
