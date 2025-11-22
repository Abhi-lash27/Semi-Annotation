import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  List<CameraDescription> cameras = [];
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    loadCameras();
  }

  Future<void> loadCameras() async {
    try {
      cameras = await availableCameras();
      setState(() {});
    } catch (e) {
      print("Error loading cameras: $e");
    }
  }

  /// SELECT CAMERA
  void selectCamera(CameraDescription cam) async {
    if (controller != null) {
      await controller!.dispose();   // dispose old controller
    }

    controller = CameraController(
      cam,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller!.initialize();
    setState(() {});
  }

  /// CAPTURE IMAGE – Proper shutdown BEFORE exit
  Future<void> captureImage() async {
    if (!controller!.value.isInitialized) return;

    final XFile file = await controller!.takePicture();
    final Uint8List bytes = await file.readAsBytes();

    /// 🔥 MOST IMPORTANT: STOP CAMERA BEFORE POP
    await controller!.dispose();
    controller = null;

    Navigator.pop(context, bytes);
  }

  /// 🔥 When user leaves without capturing → turn camera OFF
  @override
  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Camera & Capture"),
      ),
      body: Row(
        children: [
          /// LEFT PANEL – Camera list
          Container(
            width: 250,
            color: Colors.grey.shade200,
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Available Cameras",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                ...cameras.map((c) {
                  return ListTile(
                    title: Text(c.name),
                    subtitle: Text(c.lensDirection.toString()),
                    onTap: () => selectCamera(c),
                  );
                }).toList(),
              ],
            ),
          ),

          /// PREVIEW PANEL
          Expanded(
            child: controller == null || !controller!.value.isInitialized
                ? const Center(
                    child: Text(
                      "Select a camera to preview",
                      style: TextStyle(fontSize: 17),
                    ),
                  )
                : Stack(
                    children: [
                      Center(child: CameraPreview(controller!)),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: ElevatedButton(
                          onPressed: captureImage,
                          child: const Text("Capture"),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
