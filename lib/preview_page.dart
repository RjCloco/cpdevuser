import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:path/path.dart';
// import 'dart:io';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile? picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Page')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(picture!.path), fit: BoxFit.cover, width: 250),
            const SizedBox(height: 24),
            Text(picture!.name),
            TextButton(
              child: Text("UPLOAD"),
              onPressed: () async {
                if (picture == null) return;
                final fileName = basename(picture!.path);
                final destination = 'files/$fileName';

                try {
                  final ref = firebase_storage.FirebaseStorage.instance
                      .ref(destination)
                      .child('file/');

                  await ref.putFile(File(picture!.path));

                  // Get the download URL
                  final downloadURL = await ref.getDownloadURL();

                  // Store the download URL in Firestore
                  final firestore = FirebaseFirestore.instance;
                  await firestore.collection('users').add({
                    'url': downloadURL.toString(),
                    'fileName': fileName.toString(),
                    // Add other relevant data if needed
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Image uploaded successfully.'),
                    ),
                  );
                } catch (e) {
                  print('Error occurred: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
