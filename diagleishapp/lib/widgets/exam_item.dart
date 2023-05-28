import 'package:flutter/material.dart';
import 'package:diagleishapp/utils/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class ExamItem extends StatefulWidget {
  const ExamItem({
    Key? key,
    required this.document,
  }) : super(key: key);
  final QueryDocumentSnapshot document;

  @override
  State<ExamItem> createState() => _ExamItemState();
}

class _ExamItemState extends State<ExamItem> {
  final User? user = FirebaseAuth.instance.currentUser;

  void _selectModule(BuildContext context) {
    // Navigator.of(context).pushNamed(module.routes);
    print("here");
  }

  Future deleteImagens() async {
    String urlImage = widget.document['url_image'];

    FirebaseStorage.instance
        .ref()
        .child(user!.uid)
        .child('$urlImage.jpg')
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = widget.document["time_stamp"].toDate();
    final DateFormat day = DateFormat('dd/MM/yyyy');
    final DateFormat hours = DateFormat('H:m');

    return Dismissible(
      key: ValueKey(widget.document.id),
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.startToEnd) {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirmar"),
                content: const Text(
                    "Você tem certeza que deseja deletar este diagnóstico ?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      try {
                        await deleteImagens().then((value) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .collection('diagnoses')
                              .doc(widget.document.id)
                              .delete();
                          Navigator.of(context).pop(true);
                        });
                      } catch (err) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("$err"),
                          ),
                        );
                        Navigator.of(context).pop(false);
                      }
                    },
                    child: const Text(
                      "Deletar",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancelar"),
                  )
                ],
              );
            },
          );
        } else {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirmar"),
                content: const Text(
                    "Você tem certeza que deseja editar este diagnóstico?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Editar",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancelar"),
                  )
                ],
              );
            },
          );
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: ListTile(
          leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(widget.document['url_image']),
              backgroundColor: Theme.of(context).primaryColor),
          title: Text(widget.document.id.toString()),
          subtitle: Text(
              'Criado em ${day.format(dateTime)} às ${hours.format(dateTime)}'),
          dense: true,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.examView,
              arguments: widget.document,
            );
          },
        ),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.green.shade400,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
              size: 30,
            ),
            Text(
              "Editar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
            Text(
              "Deletar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
