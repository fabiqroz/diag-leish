import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid.dart';
import 'package:diagleishapp/models/info.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  dynamic file;
  bool _saved = false;
  bool _is_loading = false;
  late String urlImage;
  var uuid = const Uuid();

  _pickImageCamera() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    }
  }

  void _pickImageGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        file = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Info;

    Future addPhoto(User? user, String imageName) async {
      try {
        final ref =
            FirebaseStorage.instance.ref().child(user!.uid).child(imageName);

        await ref.putFile(file);

        urlImage = await ref.getDownloadURL();
      } catch (e) {
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("$e"),
        );
      }
    }

    void submit() async {
      if (_saved) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("As informações já foram salva"),
        ));
      } else if (file != null) {
        setState(() {
          _is_loading = true;
        });
        try {
          final User? user = FirebaseAuth.instance.currentUser;

          String image_name =
              uuid.v1(); // -> exemple : '6c84fb90-12c4-11e1-840d-7b25c5ee775a'

          await addPhoto(user, image_name);

          final infoData = {
            'symptoms': args.symptoms,
            'other_symptoms': args.otherSymptoms,
            'diagnosis': args.diagnosis,
            'other_diagnosis': args.otherDiagnosis,
            'url_image': urlImage
          };
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('diagnoses')
              .doc()
              .set(infoData)
              .then((value) => {
                    setState(() {
                      _saved = true;
                      file = null;
                      _is_loading = false;
                    })
                  });

          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text("As informações do paciente foram salvas"),
          ));
        } catch (err) {
          setState(() {
            _saved = false;
            file = null;
            _is_loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text("$err"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por favor envia uma imagem para avaliação"),
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Avaliação",
        ),
      ),
      body: _is_loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Respond to button press
                            _pickImageCamera();
                          },
                          icon: const Icon(
                            Icons.camera,
                            size: 18,
                          ),
                          label: const Text("Camera"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Respond to button press
                            _pickImageGallery();
                          },
                          icon: const Icon(
                            Icons.folder,
                            size: 18,
                          ),
                          label: const Text("Gallery"),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: (file != null)
                        ? Image.file(
                            file,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          )
                        : Container(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                    onPressed: _is_loading ? null : submit,
                    icon: const Icon(Icons.save),
                    label: const Text("Salvar Resultado")),
              ],
            ),
    );
  }
}
