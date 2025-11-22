import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:semi_anotation/screens/camera_capture_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uint8List? imageBytes;

  /// PICK IMAGE FROM SYSTEM
  Future<void> pickImage() async {
    final image = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      imageBytes = image;
    });
  }

  /// OPEN CAMERA PAGE & GET CAPTURED IMAGE
  Future<void> captureImage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CameraCaptureScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        imageBytes = result;
      });
    }
  }

  /// RESET IMAGE
  void resetImage() {
    setState(() {
      imageBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔹 Top AppBar with Reset Button
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Image Annotator"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Image",
            onPressed: resetImage,
          ),
        ],
      ),

      body: Row(
        children: [
          /// 🔹 LEFT PANEL — Upload & Capture Buttons
          Container(
            width: 250,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text("Upload Image"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: captureImage,
                  child: const Text("Capture Image"),
                ),
              ],
            ),
          ),

          /// 🔹 CENTER — Display the image
          Expanded(
            child: Center(
              child: imageBytes == null
                  ? const Text(
                      "No image selected",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    )
                  : Image.memory(
                      imageBytes!,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}