import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/ApiService .dart';

class AddMusicForm extends StatefulWidget {
  const AddMusicForm({super.key});

  @override
  State<AddMusicForm> createState() => _AddMusicFormState();
}

class _AddMusicFormState extends State<AddMusicForm> {
  final titleCtrl = TextEditingController();
  final singerCtrl = TextEditingController();
  final langCtrl = TextEditingController();
  final typeCtrl = TextEditingController();

  File? selectedImage;
  File? selectedAudio;

  final ImagePicker picker = ImagePicker();

  // Pick image
  Future pickImage() async {
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        selectedImage = File(img.path);
      });
    }
  }

  // Pick audio file
  Future pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      setState(() {
        selectedAudio = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Music Data")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: singerCtrl, decoration: const InputDecoration(labelText: "Singer Name")),
            TextField(controller: langCtrl, decoration: const InputDecoration(labelText: "Language")),
            TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: "Music Type")),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Select Image"),
            ),
            selectedImage != null
                ? Image.file(selectedImage!, height: 100)
                : const Text("No image selected"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickAudio,
              child: const Text("Select Audio "),
            ),
            selectedAudio != null
                ? Text("Audio: ${selectedAudio!.path.split('/').last}")
            // file name liya gaya
                : const Text("No audio selected"),

            const SizedBox(height: 30),

            ElevatedButton(
              child: const Text("Submit"),
              onPressed: () async {
                if (selectedImage == null || selectedAudio == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Select image & audio first")),
                  );
                  return;
                }

                bool success = await ApiService.uploadMusic(
                  title: titleCtrl.text,
                  singer: singerCtrl.text,
                  language: langCtrl.text,
                  type: typeCtrl.text,
                  image: selectedImage!,
                  audio: selectedAudio!,
                );

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Uploaded Successfully!")),
                  );

                  // 🔥 CLEAR ALL FIELDS HERE
                  setState(() {
                    titleCtrl.clear();
                    singerCtrl.clear();
                    langCtrl.clear();
                    typeCtrl.clear();
                    selectedImage = null;
                    selectedAudio = null;
                  });

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Upload Failed!")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}