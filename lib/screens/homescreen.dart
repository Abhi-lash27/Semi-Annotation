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

  Future<void> pickImage() async {
    final image = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      imageBytes = image;
    });
  }

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          /// LEFT PANEL
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

          /// CENTER: DISPLAY IMAGE
          Expanded(
            child: Center(
              child: imageBytes == null
                  ? const Text(
                      "No image selected",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    )
                  : Image.memory(imageBytes!, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
