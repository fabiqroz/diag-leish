import 'package:flutter/material.dart';
import 'package:diagleishapp/database/exam_type.dart';
import 'package:diagleishapp/widgets/exam_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  ExamType examType = const ExamType();
  late String searchString = "";
  final User? user = FirebaseAuth.instance.currentUser;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: (searchString.trim() == '')
          ? FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('diagnoses')
              .snapshots()
          : FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('diagnoses')
              .where('keys', arrayContains: searchString)
              .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text("Não há nenhum resultado disponível."),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final data = snapshot.data!.docs[index];
            return ExamItem(document: data);
          },
        );
      },
    );
  }
}
