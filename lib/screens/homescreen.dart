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

  void resetImage() {
    setState(() {
      imageBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      /// 🔹 TOP APP BAR
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
          // 🔹 LEFT SIDEBAR (Scroll when images increase)
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
                      children: List.generate(
                        10,
                        (index) => Container(
                          margin: const EdgeInsets.all(8),
                          height: 120,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------------------------------------------------------------
          // 🔹 CENTER CANVAS SECTION
          // ---------------------------------------------------------------
          Expanded(
            child: Column(
              children: [
                // MAIN IMAGE CANVAS
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

                // BUTTON ROW
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
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

                // MODEL DROPDOWN
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
          // 🔹 RIGHT PANEL (Class Labels + Annotations)
          // ---------------------------------------------------------------
          Container(
            width: 250,
            color: Colors.grey.shade200,
            child: Column(
              children: [
                // CLASS LABELS
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      height: 35,
                      color: Colors.white,
                    ),
                  ),
                ),

                const Divider(thickness: 1),

                // ANNOTATIONS LIST
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      height: 35,
                      color: Colors.white,
                    ),
                  ),
                ),

                // TRAIN BUTTON
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