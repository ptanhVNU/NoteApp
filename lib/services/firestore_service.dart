import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/models/task.dart';

class FirestoreService {
  FirebaseFirestore firebaseStorage = FirebaseFirestore.instance;

  // add Task to Firebase
  Future addTask({required String title, required String description}) async {
    final docTask = firebaseStorage.collection('notes').doc();

    final task = Task(
      id: docTask.id,
      title: title,
      description: description,
      date: Timestamp.fromDate(DateTime.now()),
    );
    final json = task.toJson();

    await docTask.set(json);
  }

  // edit Task
  Future editTask({
    required String docId,
    required String title,
    required String description,
  }) async {
    try {
      await firebaseStorage.collection('notes').doc(docId).update({
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
  Future deleteTask(String docId) async {
    try {
      await firebaseStorage.collection('notes').doc(docId).delete();
    } catch (e) {
      print(e);
    }
  }
}
