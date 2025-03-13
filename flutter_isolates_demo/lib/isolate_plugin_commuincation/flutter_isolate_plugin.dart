import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlutterIsolateExample extends StatefulWidget {
  const FlutterIsolateExample({super.key});

  @override
  State<FlutterIsolateExample> createState() => _FlutterIsolateExampleState();
}

class _FlutterIsolateExampleState extends State<FlutterIsolateExample> {
  String _status = "Tap button to fetch username";
  FlutterIsolate? _isolate;

  @override
  void initState() {
    super.initState();
    _saveUsername(); // Save a sample username when the app starts
  }

  // ✅ Save a sample username in SharedPreferences (main isolate)
  Future<void> _saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", "FlutterIsolateUser");
  }

  // ✅ Start an isolate to fetch the username
  void _fetchUsername() async {
    final receivePort = ReceivePort();

    // Spawn the isolate with the sendPort
    _isolate = await FlutterIsolate.spawn(_isolateMain, receivePort.sendPort);

    // Listen for messages from the isolate
    receivePort.listen((message) {
      setState(() {
        _status = "Stored Username: $message";
      });
    });
  }

  // ✅ Isolate function: Reads username from SharedPreferences
  static void _isolateMain(SendPort sendPort) async {
    try {
      // Access SharedPreferences inside the isolate (flutter_isolate allows this directly)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString("username");

      // Send result back to the main isolate
      sendPort.send(username ?? "No username found");
    } catch (e) {
      sendPort.send("Error: $e");
    }
  }

  @override
  void dispose() {
    _isolate?.kill(priority: Isolate.immediate); // Kill the isolate when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FlutterIsolate Plugin Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _fetchUsername,
              child: const Text("Fetch Username from Isolate"),
            ),
            const SizedBox(height: 20),
            Text(_status, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
