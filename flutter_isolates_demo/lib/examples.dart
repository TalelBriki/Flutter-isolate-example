import 'package:flutter/material.dart';

import 'exmples/encryption.dart';
import 'exmples/file_reading.dart';
import 'exmples/image_processing.dart';
import 'exmples/json_parsing.dart';


class RealLifeExamples extends StatelessWidget {
  const RealLifeExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Real-Life Examples")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _exampleBtn(
                context: context,
                title: "Image Processing",
                subtitle: "Converting an image to grayscale or resizing it.",
                screen: const ImageProcessingScreen(),
              ),
              _exampleBtn(
                context: context,
                title: "File Reading",
                subtitle: "Reading large files without blocking the UI.",
                screen: const FileReadingScreen(),
              ),
              _exampleBtn(
                context: context,
                title: "JSON Parsing",
                subtitle: "Parsing a large JSON file efficiently.",
                screen: const JsonParsingScreen(),
              ),
              _exampleBtn(
                context: context,
                title: "Encryption",
                subtitle: "Encrypting and decrypting data in the background.",
                screen: const EncryptionScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _exampleBtn({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget screen,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.blue.withOpacity(0.5),
          ),
          padding: const EdgeInsets.all(10.0),
          height: 80,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black)),
              Text(subtitle, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
