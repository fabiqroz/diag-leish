import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:diagleishapp/models/info.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  dynamic file;
  dynamic fileResponse;
  bool _saved = false;
  bool isLoading = false;
  bool isProcessing = false;
  late String urlImage;
  var uuid = const Uuid();

  static int timerValue = 190;
  int _countdown = timerValue;
  late Timer _timer;

  void startTimer() {
    setState(() {
      isProcessing = true;
    });
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_countdown == 0) {
          setState(() {
            isProcessing = false;
            _countdown = timerValue;

            timer.cancel();
          });
        } else {
          setState(() {
            _countdown--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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

    classify() async {
      //for multipartrequest
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.202.252:8000/upload/'));
      //for token
      // request.headers.addAll({"Authorization": "Bearer token"});

      request.files.add(await http.MultipartFile.fromPath(
          'file_uploaded', file.path,
          contentType: MediaType("image", "jpg")));

      //for completeing the request
      var response = await request.send();

      //for getting and decoding the response into json format
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);

      if (response.statusCode == 200) {
        Uint8List bytesImage =
            const Base64Decoder().convert(responseData.toString());
        final dir = await getTemporaryDirectory();
        final path = "${dir.path}/result.jpg";
        fileResponse = await File(path).writeAsBytes(bytesImage);
        setState(() {
          file = fileResponse;
        });
      } else {
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Erro with base64 convertion"),
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
          isLoading = true;
        });
        try {
          final User? user = FirebaseAuth.instance.currentUser;

          String imageName =
              uuid.v1(); // -> exemple : '6c84fb90-12c4-11e1-840d-7b25c5ee775a'

          await addPhoto(user, imageName);

          final infoData = {
            "time_stamp": DateTime.now(),
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
                      isLoading = false;
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
            isLoading = false;
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
      body: isLoading
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    Text(
                      "Salvando os dados, você será redirecionado para página inicial",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      "Selecione uma Imagem",
                      style: TextStyle(fontSize: 16),
                    ),
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
                            Divider(
                              color: Theme.of(context).colorScheme.secondary,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: (file != null)
                            ? Stack(
                                children: [
                                  Image.file(
                                    file,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                  isProcessing
                                      ? Container(
                                          width: double.infinity,
                                          color:
                                              Colors.purple.withOpacity(0.45),
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Processando imagem, tempo restante é de: $_countdown segundos",
                                                style: const TextStyle(
                                                    fontSize: 24,
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              CircularProgressIndicator(
                                                value: 1 -
                                                    (_countdown / timerValue),
                                              )
                                            ],
                                          ),
                                        )
                                      : const Text(""),
                                ],
                              )
                            : Container(),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton.icon(
                          onPressed: isLoading || isProcessing
                              ? null
                              : () {
                                  startTimer();
                                  classify();
                                },
                          icon: const Icon(Icons.search),
                          label: const Text("Detectar"),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton.icon(
                          onPressed: isLoading || isProcessing ? null : submit,
                          icon: const Icon(Icons.save),
                          label: const Text("Salvar"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
