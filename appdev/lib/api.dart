import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpGetExample(),
    );
  }
}

class HttpGetExample extends StatefulWidget {
  @override
  _HttpGetExampleState createState() => _HttpGetExampleState();
}

class _HttpGetExampleState extends State<HttpGetExample> {
  String _response = "Press the button to fetch data";

  Future<void> fetchData() async {
    final String url = "https://api.sampleapis.com/codingresources/codingResources"; // Change this to your IP or sample API
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _response = jsonDecode(response.body).toString();
        });
      } else {
        setState(() {
          _response = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Failed to load data: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter HTTP GET Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_response, textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchData,
              child: Text("Fetch Data"),
            ),
          ],
        ),
      ),
    );
  }
}
