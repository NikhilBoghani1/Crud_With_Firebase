import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreService {
  // get collection of notes

  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

// CREATE : add new note

  Future<void> addNote(String note) {
    return notes.add(
      {
        'note': note,
        'timestamp': Timestamp.now(),
      },
    );
  }

// READ : get notes from database

  Stream<QuerySnapshot> getNotedStream() {
    final notesStream =
        notes.orderBy("timestamp", descending: true).snapshots();
    return notesStream;
  }

// UPDATE : update notes given a doc id

  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update(
      {
        'note': newNote,
        'timestamp': Timestamp.now(),
      },
    );
  }

// DELETE : delete notes given a doc id

Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
}
}
