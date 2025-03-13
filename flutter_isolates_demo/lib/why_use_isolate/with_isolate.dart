import 'dart:isolate';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:lottie/lottie.dart';

class WithIsolate extends StatefulWidget {
  const WithIsolate({super.key});

  @override
  State<WithIsolate> createState() => _WithIsolateState();
}

class _WithIsolateState extends State<WithIsolate> {
  String _result = "Tap a button to start";

  Future<void> _runHeavyTask() async {
    setState(() {
      _result = "Processing...";
    });

    // Create a new isolate and send a message
    final receivePort = ReceivePort();
    await Isolate.spawn(_heavyComputation, receivePort.sendPort);

    // Listen for the result
    receivePort.listen((message) {
      setState(() {
        _result = "Task completed! Sum: $message";
      });
    });
  }

  // Function that runs in the isolate
  static void _heavyComputation(SendPort sendPort) {
    int sum = 0;
    for (int i = 0; i < 500000000; i++) {
      sum += i;
    }
    sendPort.send(sum); // Send result back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('With Isolate')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_result, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _runHeavyTask,
              child: const Text("Run Task"),
            ),
            const SizedBox(height: 20),
            Lottie.asset('assets/lotties/loading_lottie.json'),

          ],
        ),
      ),
    );
  }
}
