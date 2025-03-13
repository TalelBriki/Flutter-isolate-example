import 'dart:isolate';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../widgets/custom_annimation.dart';

class FileReadingScreen extends StatefulWidget {
  const FileReadingScreen({super.key});

  @override
  State<FileReadingScreen> createState() => _FileReadingScreenState();
}

class _FileReadingScreenState extends State<FileReadingScreen> {
  String _status = "Tap to generate and read file";
  late File _file; // Declare file variable

  @override
  void initState() {
    super.initState();
  }

  Future<void> _generateAndReadFile() async {
    setState(() {
      _status = "Generating file...";
    });

    // Get the temporary directory path
    Directory tempDir = await getTemporaryDirectory();
    _file = File("${tempDir.path}/large_file.txt");

    // Generate a large file if it doesn't exist
    if (!await _file.exists()) {
      await _generateLargeFile(_file);
    }

    // Now proceed to read the file after it is generated
    setState(() {
      _status = "Reading file...";
    });

    final receivePort = ReceivePort();
    await Isolate.spawn(_readLargeFile, [_file.path, receivePort.sendPort]);

    receivePort.listen((message) {
      setState(() {
        _status = "File Read Completed! Content Length: ${message}";
      });
    });
  }

  // Function to generate a large file (for testing purposes)
  Future<void> _generateLargeFile(File file) async {
    var largeContent = "This is a large file content. " * 10000; // Large content for testing
    await file.writeAsString(largeContent);
  }

  static void _readLargeFile(List<dynamic> args) async {
    final filePath = args[0];
    final sendPort = args[1] as SendPort;

    // Perform the file reading in the worker isolate
    try {
      File file = File(filePath);
      String content = await file.readAsString();
      sendPort.send(content); // Send the content back to the main isolate
    } catch (e) {
      sendPort.send("Error reading file: $e"); // Send error if file reading fails
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Ensure file is deleted when the screen is disposed
    _file.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Reading")),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(20),

        child:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _generateAndReadFile,
                child: const Text("Generate and Read File"),
              ),
              const SizedBox(height: 20),
              CustomAnnimation(),

            ],
          ),
        ),
        )
      ),
    );
  }
}
