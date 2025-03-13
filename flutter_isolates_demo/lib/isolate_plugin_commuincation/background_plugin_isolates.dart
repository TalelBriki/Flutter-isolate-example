import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundPluginIsolates extends StatefulWidget {
  const BackgroundPluginIsolates({super.key});

  @override
  State<BackgroundPluginIsolates> createState() => _BackgroundPluginIsolatesState();
}

class _BackgroundPluginIsolatesState extends State<BackgroundPluginIsolates> {
  String _status = "Tap button to fetch username";

  @override
  void initState() {
    super.initState();
    _saveUsername(); // Save a username when the app starts (for testing)
  }

  // ✅ Save a sample username in SharedPreferences (main isolate)
  Future<void> _saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", "FlutterUser");
  }

  // ✅ Fetch the username using an Isolate
  void _fetchUsername() async {
    final receivePort = ReceivePort();
    RootIsolateToken? rootIsolateToken = RootIsolateToken.instance;

    if (rootIsolateToken == null) {
      setState(() {
        _status = "Error: RootIsolateToken is null!";
      });
      return;
    }

    // Spawn an isolate to fetch the username
    await Isolate.spawn(_isolateMain, [rootIsolateToken, receivePort.sendPort]);

    // Listen for the response from the isolate
    receivePort.listen((message) {
      setState(() {
        _status = "Stored Username: $message";
      });
    });
  }

  // ✅ Isolate function: Reads username from SharedPreferences
  static void _isolateMain(List<dynamic> args) async {
    final RootIsolateToken rootIsolateToken = args[0];
    final SendPort sendPort = args[1];

    try {
      // Initialize background isolate with the RootIsolateToken
      BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

      // Fetch stored username from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString("username");

      // Send the result back to the main isolate
      sendPort.send(username ?? "No username found");
    } catch (e) {
      sendPort.send("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RootIsolateToken Example")),
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
