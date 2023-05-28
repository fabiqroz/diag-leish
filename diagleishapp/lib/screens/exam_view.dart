// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExamView extends StatefulWidget {
  const ExamView({super.key});

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  @override
  Widget build(BuildContext context) {
    final document =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resultado"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(document['url_image']),
            const SizedBox(
              height: 10,
            ),
            Text("Outros Diagnósticos: " + document['other_diagnosis']),
            const SizedBox(
              height: 10,
            ),
            Text("Outros Simtomas: " + document['other_symptoms']),
            const SizedBox(
              height: 10,
            ),
            Text("Simtomas Normalizado: ${document['symptoms']}"),
          ],
        ),
      ),
    );
  }
}
