import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class AddPostScreen extends StatelessWidget {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final FirestoreService _firestore = FirestoreService();

  void addPost(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _firestore.addPost(
        user.uid,
        titleController.text,
        contentController.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Post")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Judul')),
            TextField(controller: contentController, decoration: InputDecoration(labelText: 'Isi')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => addPost(context),
              child: Text("Post"),
            )
          ],
        ),
      ),
    );
  }
}