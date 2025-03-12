import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IsolateCommunicationScreen extends StatefulWidget {
  @override
  _IsolateCommunicationScreenState createState() => _IsolateCommunicationScreenState();
}

class _IsolateCommunicationScreenState extends State<IsolateCommunicationScreen> {
  String _message = "Press the button to start communication";

  Future<void> _startCommunication() async {
    /// Create a port to receive messages
    final receivePort = ReceivePort();
    /// Spawn the isolate and send the port
    await Isolate.spawn(workerIsolate, receivePort.sendPort);

   /// Listen for messages from the worker isolate
    receivePort.listen((message) {
      setState(() {
        _message = "Worker Isolate says: $message";
      });
    });
  }

  static void workerIsolate(SendPort sendPort) {
    /// Simulate some work
    String result = "Hello from Worker Isolate!";

    /// Send the result back to the main isolate
    sendPort.send(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Isolate Communication")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startCommunication,
              child: const Text("Start Isolate"),
            ),
          ],
        ),
      ),
    );
  }
}