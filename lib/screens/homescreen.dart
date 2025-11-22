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

  // Sidebar saved thumbnails list
  List<Uint8List> savedImages = [];

  // PICK IMAGE
  Future<void> pickImage() async {
    final image = await ImagePickerWeb.getImageAsBytes();
    setState(() {
      imageBytes = image;
    });
  }

  // CAPTURE IMAGE
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

  // RESET CURRENT IMAGE
  void resetImage() {
    setState(() {
      imageBytes = null;
    });
  }

  // SAVE IMAGE TO SIDEBAR
  void saveImageToSidebar() {
    if (imageBytes != null) {
      setState(() {
        savedImages.add(imageBytes!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        centerTitle: true,
        elevation: 1,
        title: const Text(
          "Semi-Annotation",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),

      body: Row(
        children: [
          // ---------------------------------------------------------------
          // 🔹 LEFT SIDEBAR — scrollable saved images
          // ---------------------------------------------------------------
          Container(
            width: 200,
            color: Colors.grey.shade300,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Dataset Folder",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (var img in savedImages)
                          Container(
                            margin: const EdgeInsets.all(8),
                            height: 120,
                            width: 150,
                            color: Colors.white,
                            child: Image.memory(img, fit: BoxFit.cover),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------------------------------------------------------------
          // 🔹 CENTER CANVAS AREA
          // ---------------------------------------------------------------
          Expanded(
            child: Column(
              children: [
                // Main canvas
                Expanded(
                  child: Container(
                    color: Colors.grey.shade200,
                    margin: const EdgeInsets.all(10),
                    child: Center(
                      child: imageBytes == null
                          ? const Text(
                              "No image selected",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.black54),
                            )
                          : Image.memory(imageBytes!, fit: BoxFit.contain),
                    ),
                  ),
                ),

                // Upload / Capture buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: pickImage,
                        child: const Text("Upload Image"),
                      ),
                      ElevatedButton(
                        onPressed: captureImage,
                        child: const Text("Capture Image"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Save / Reset buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: saveImageToSidebar,
                        child: const Text("Save Image"),
                      ),
                      ElevatedButton(
                        onPressed: resetImage,
                        child: const Text("Reset Image"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ML Model Dropdown
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Choose ML Model",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: DropdownButton(
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                              value: "model1",
                              child: Text("Model_1.pt"),
                            ),
                          ],
                          onChanged: (value) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ---------------------------------------------------------------
          // 🔹 RIGHT PANEL — Class Labels + Annotations
          // ---------------------------------------------------------------
          Container(
            width: 250,
            color: Colors.grey.shade200,
            child: Column(
              children: [
                // Class labels
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Class Labels",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                Column(
                  children: List.generate(
                    4,
                    (index) => Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      height: 35,
                      color: Colors.white,
                    ),
                  ),
                ),

                const Divider(),

                // Annotation items
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Annotations",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 10,
                    itemBuilder: (context, index) => Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      height: 35,
                      color: Colors.white,
                    ),
                  ),
                ),

                // TRAIN button
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "TRAIN",
                      style: TextStyle(fontSize: 18),
                    ),
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