import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../widgets/custom_annimation.dart';

class ImageProcessingScreen extends StatefulWidget {
  const ImageProcessingScreen({super.key});

  @override
  State<ImageProcessingScreen> createState() => _ImageProcessingScreenState();
}

class _ImageProcessingScreenState extends State<ImageProcessingScreen> {
  String _status = "Select an image to process";
  img.Image? _originalImage; // Nullable type
  img.Image? _processedImage; // Nullable type
  bool _isProcessing = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _status = "Processing Image...";
        _isProcessing = true;
      });

      // Load the image
      final imageBytes = await pickedFile.readAsBytes();
      _originalImage = img.decodeImage(Uint8List.fromList(imageBytes));

      // Ensure image is loaded before proceeding
      if (_originalImage != null) {
        // Process the image in an isolate
        final receivePort = ReceivePort();
        await Isolate.spawn(_convertToGrayscale, [imageBytes, receivePort.sendPort]);

        receivePort.listen((message) {
          setState(() {
            _status = "Image Processed!";
            _processedImage = message;
            _isProcessing = false;
          });
        });
      } else {
        setState(() {
          _status = "Failed to load image.";
          _isProcessing = false;
        });
      }
    }
  }

  static void _convertToGrayscale(List<dynamic> args) {
    final imageBytes = args[0] as List<int>;
    final sendPort = args[1] as SendPort;

    // Decode the image from bytes
    img.Image image = img.decodeImage(Uint8List.fromList(imageBytes))!;

    // Convert the image to grayscale
    img.grayscale(image);

    // Send the processed image back
    sendPort.send(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Processing")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_status, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Pick Image to Process"),
              ),
              const SizedBox(height: 20),
              _isProcessing
                  ? const CustomAnnimation()
                  : Column(
                children: [
                  if (_originalImage != null) ...[
                    Text("Original Image:"),
                    Image.memory(Uint8List.fromList(img.encodeJpg(_originalImage!))),
                  ],
                  if (_processedImage != null) ...[
                    const SizedBox(height: 20),
                    Text("Processed Image (Grayscale):"),
                    Image.memory(Uint8List.fromList(img.encodeJpg(_processedImage!))),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
