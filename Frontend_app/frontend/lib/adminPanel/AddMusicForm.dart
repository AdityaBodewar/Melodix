import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/HomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/handleApi/ApiService%20.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),

      body: Center(
        child: ElevatedButton(
          child: const Text("Add Songs"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMusicForm()),
            );
          },
        ),
      ),
    );
  }
}


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
  double uploadProgress = 0.0;
  bool isUploading = false;

  String? userToken;


  final ImagePicker picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    loadToken();
  }

  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("token");
    print("Loaded Token: $userToken");
  }


  Future pickImage() async {
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => selectedImage = File(img.path));
    }
  }

  Future pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() => selectedAudio = File(result.files.single.path!));
    }
  }


  bool validateFields() {
    if (titleCtrl.text.isEmpty ||
        singerCtrl.text.isEmpty ||
        langCtrl.text.isEmpty ||
        typeCtrl.text.isEmpty ||
        selectedImage == null ||
        selectedAudio == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("All fields are required!")));
      return false;
    }
    return true;
  }

  InputDecoration buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.deepPurple),
      filled: true,
      fillColor: Colors.grey,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
      appBar: AppBar(
        title: const Text("Add Music Data"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                TextField(
                  controller: titleCtrl,
                  style: TextStyle(color: Colors.white,),
                  decoration: buildInputDecoration(
                    "Song Title",
                    Icons.music_note,

                  ),
                ),



                const SizedBox(height: 15),

                TextField(
                    controller: singerCtrl,
                    decoration: buildInputDecoration("Singer Name", Icons.person)),

                const SizedBox(height: 15),

                TextField(
                    controller: langCtrl,
                    decoration: buildInputDecoration("Language", Icons.language)),

                const SizedBox(height: 15),

                TextField(
                    controller: typeCtrl,
                    decoration: buildInputDecoration("Music Type", Icons.category)),

                const SizedBox(height: 20),

                // IMAGE PICK BUTTON
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.image,color: Colors.white,),
                  onPressed: pickImage,
                  label: Text("Select Image",style: TextStyle(color: Colors.white),),
                ),

                const SizedBox(height: 10),

                selectedImage != null
                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(selectedImage!, height: 120))
                    : const Text("No image selected", style: TextStyle(color: Colors.grey)),

                const SizedBox(height: 20),

                // AUDIO PICK BUTTON
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.audio_file,color: Colors.white,),
                  onPressed: pickAudio,
                  label: const Text("Select Audio File",style: TextStyle(color: Colors.white),),
                ),

                const SizedBox(height: 10),

                selectedAudio != null
                    ? Text("Audio: ${selectedAudio!.path.split('/').last}",
                    style: const TextStyle(fontWeight: FontWeight.bold))
                    : const Text("No audio selected", style: TextStyle(color: Colors.grey)),

                const SizedBox(height: 25),

                // PROGRESS BAR
                if (isUploading) ...[
                  LinearProgressIndicator(
                    value: uploadProgress,
                    minHeight: 8,
                    color: Colors.deepPurple,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text("${(uploadProgress * 100).toStringAsFixed(0)}% Uploaded",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 20),
                ],

                // SUBMIT BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Upload Song", style: TextStyle(fontSize: 17)),
                  onPressed: () async {
                    if (!validateFields()) return;

                    setState(() {
                      isUploading = true;
                      uploadProgress = 0.0;
                    });

                    bool success = await ApiService.uploadMusic(
                      title: titleCtrl.text,
                      singer: singerCtrl.text,
                      language: langCtrl.text,
                      type: typeCtrl.text,
                      token: userToken!,
                      image: selectedImage!,
                      audio: selectedAudio!,
                      onProgress: (sent, total) {
                        setState(() => uploadProgress = sent / total);
                      },
                    );

                    setState(() => isUploading = false);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Uploaded Successfully!")),

                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );

                      setState(() {
                        titleCtrl.clear();
                        singerCtrl.clear();
                        langCtrl.clear();
                        typeCtrl.clear();
                        selectedImage = null;
                        selectedAudio = null;
                        uploadProgress = 0.0;
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
        ),
      ),
    );
  }
}
