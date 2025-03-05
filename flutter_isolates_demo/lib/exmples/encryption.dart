import 'dart:isolate';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert'; // For utf8.encode

class EncryptionScreen extends StatefulWidget {
  const EncryptionScreen({super.key});

  @override
  State<EncryptionScreen> createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  String _encryptedText = "Tap the button to encrypt";
  String _decryptedText = "";

  // Encrypt data
  Future<void> _encryptData() async {
    setState(() {
      _encryptedText = "Encrypting...";
    });

    final receivePort = ReceivePort();

    // Spawn an isolate to handle encryption
    await Isolate.spawn(_performEncryption, receivePort.sendPort);

    receivePort.listen((message) {
      setState(() {
        _encryptedText = "Encrypted: $message";
      });

      // Once encrypted, perform decryption
      _decryptData(message);
    });
  }

  // Decrypt data
  Future<void> _decryptData(String encryptedText) async {
    setState(() {
      _decryptedText = "Decrypting...";
    });

    final receivePort = ReceivePort();

    // Spawn an isolate to handle decryption
    await Isolate.spawn(_performDecryption, [encryptedText, receivePort.sendPort]);

    receivePort.listen((message) {
      setState(() {
        _decryptedText = "Decrypted: $message";
      });
    });
  }

  // Perform encryption in a separate isolate
  static void _performEncryption(SendPort sendPort) {
    // Ensure key is exactly 32 bytes (256 bits) for AES-256
    final key = _getAESKey('32characterlongsecretkey1234'); // Key must be 32 bytes for AES-256
    final iv = encrypt.IV.allZerosOfLength(16); // Initialization Vector (16 bytes for AES)
    final encrypter = encrypt.Encrypter(encrypt.AES(key, padding: 'PKCS7'));

    // Encrypt the data
    final encrypted = encrypter.encrypt("Hello, Flutter!", iv: iv);
    sendPort.send(encrypted.base64); // Send back the encrypted text
  }

  // Perform decryption in a separate isolate
  static void _performDecryption(List<dynamic> args) {
    final encryptedText = args[0];
    final sendPort = args[1] as SendPort;

    // Ensure key is exactly 32 bytes (256 bits) for AES-256
    final key = _getAESKey('32characterlongsecretkey1234'); // Key must be 32 bytes for AES-256
    final iv = encrypt.IV.allZerosOfLength(16); // Initialization Vector (16 bytes for AES)
    final encrypter = encrypt.Encrypter(encrypt.AES(key, padding: 'PKCS7'));

    // Decrypt the data
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    sendPort.send(decrypted); // Send back the decrypted text
  }

  // Ensure the key is exactly 32 bytes (256 bits)
  static encrypt.Key _getAESKey(String key) {
    // Convert the string to bytes using utf8.encode
    List<int> keyBytes = utf8.encode(key);

    // If the key is not 32 bytes, truncate or pad it
    if (keyBytes.length > 32) {
      keyBytes = keyBytes.sublist(0, 32); // Truncate to 32 bytes
    } else if (keyBytes.length < 32) {
      keyBytes = keyBytes + List.filled(32 - keyBytes.length, 0); // Pad with 0's
    }

    return encrypt.Key(Uint8List.fromList(keyBytes)); // Ensure the key is 32 bytes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Encryption & Decryption")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_encryptedText, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text(_decryptedText, style: const TextStyle(fontSize: 18, color: Colors.green)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _encryptData,
              child: const Text("Encrypt & Decrypt Data"),
            ),
          ],
        ),
      ),
    );
  }
}
