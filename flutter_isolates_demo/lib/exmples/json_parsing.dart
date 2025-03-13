import 'dart:isolate';
import 'dart:convert';
import 'package:flutter/material.dart';

import '../widgets/custom_annimation.dart';

class JsonParsingScreen extends StatefulWidget {
  const JsonParsingScreen({super.key});

  @override
  State<JsonParsingScreen> createState() => _JsonParsingScreenState();
}

class _JsonParsingScreenState extends State<JsonParsingScreen> {
  String _status = "Tap to parse JSON";

  Future<void> _parseJson() async {
    setState(() {
      _status = "Parsing JSON...";
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(_parseLargeJson, receivePort.sendPort);

    receivePort.listen((message) {
      setState(() {
        _status = "JSON Parsed Successfully!";
      });
    });
  }

  static void _parseLargeJson(SendPort sendPort) {
    String jsonString = '{"data": ${List.generate(100000, (index) => index)}}';
    Map<String, dynamic> jsonData = json.decode(jsonString);
    sendPort.send(jsonData.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("JSON Parsing")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            CustomAnnimation(),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _parseJson,
              child: const Text("Parse JSON"),
            ),
          ],
        ),
      ),
    );
  }
}
