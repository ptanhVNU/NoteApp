import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note.dart';

class FirestoreService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // add Task to Firebase

  Future addNote({
    required String title,
    required String description,
  }) async {
    final docNote = firebaseFirestore.collection('notes').doc();

    final note = Note(
      id: docNote.id,
      title: title,
      description: description,
      date: Timestamp.fromDate(DateTime.now()),
    );
    final json = note.toJson();

    await docNote.set(json);
  }

  // edit Task
  Future editNote({
    required String docId,
    required String title,
    required String description,
  }) async {
    try {
      await firebaseFirestore.collection('notes').doc(docId).update({
        // request object
        // tao 1 model chua cac thong tin can update len

        // Log API de xem request minh len dung k
        // print(objectReques)

        'title': title,
        'description': description
      });
      log('Request: $title');
    } catch (e) {
      print(e);
    }
  }

  //delete Task
  Future delNote(String docId) async {
    try {
      await firebaseFirestore.collection('notes').doc(docId).delete();
    } catch (e) {
      print(e);
    }
  }
}
