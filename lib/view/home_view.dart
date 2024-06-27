import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/services/firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // For Time - Date

// Assuming you have a Firebase timestamp stored in a variable called `firebaseTimestamp`
  Timestamp firebaseTimestamp =
      Timestamp.fromMillisecondsSinceEpoch(1624699200000); // Example timestamp

  DateTime dateTime = DateTime.timestamp();
  String formattedTime = DateFormat.Hm().format(
    DateTime.now(),
  ); // Format to display only hours and minutes

  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textcontroller = TextEditingController();

  void openNoteBox(String? docID, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(CupertinoIcons.paperclip),
        title: Text(
          docID == null ? "Add New Note" : "Update Note",
          style: TextStyle(
            fontFamily: "PoppinsR",
            fontSize: 18,
          ),
        ),
        content: TextFormField(
          style: TextStyle(
            fontFamily: "PoppinsR",
          ),
          controller: textcontroller,
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (docID == null) {
                firestoreService.addNote(textcontroller.text);
              } else {
                firestoreService.updateNote(docID, textcontroller.text);
              }
              textcontroller.clear();
              Navigator.pop(context);
            },
            child: Text(
              docID == null ? "Add Note" : "Update Note",
              style: TextStyle(
                color: Colors.black,
                fontFamily: "PoppinsR",
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Note",
          style: TextStyle(
            fontFamily: "PoppinsB",
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNoteBox(null, context),
        child: Icon(
          CupertinoIcons.add,
          size: 27,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotedStream(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: noteList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = noteList[index];
                Timestamp timestamp = document['timestamp'];

                DateTime dateTime = timestamp.toDate();
                String formattedTime = DateFormat.jm().format(dateTime); //

                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteText = data["note"];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                thickness: 2.2,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "$formattedTime",
                                style: TextStyle(
                                  fontFamily: "PoppinsR",
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 2.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ListTile(
                          title: Text(
                            noteText,
                            style: TextStyle(
                              fontFamily: "PoppinsR",
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () => openNoteBox(docID, context),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 14),
                              backgroundColor:
                                  CupertinoColors.activeBlue.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "PoppinsR",
                                fontSize: 15,
                              ),
                            ),
                          ),
                          SizedBox(width: 30),
                          ElevatedButton(
                            onPressed: () => firestoreService.deleteNote(docID),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 14),
                              backgroundColor: CupertinoColors.destructiveRed
                                  .withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "PoppinsR",
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "Sorry...",
                style: TextStyle(
                  fontFamily: "PoppinsR",
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
