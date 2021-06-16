import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_leh/screens/database.dart';

class DeleteDialog {
  final String docId;
  final DatabaseService db = DatabaseService();

  DeleteDialog({this.docId});

  Future showDeleteDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Alert"),
        content: Text("Confirm to delete post?"),
        actions: [
          yesButton(context),
          noButton(context),
        ],);
    });
  }

  Widget noButton(BuildContext context) =>
      TextButton(
        child: Text("NO"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

  Widget yesButton(BuildContext context) =>
      TextButton(
        child: Text("YES"),
        onPressed: () {
          updateSaved();
          db.delete(docId);
          Navigator.of(context).pop();
          Navigator.pop(context);
        },
      );

  updateSaved() {
    List<dynamic> saved;
    String userDocID;
    List<dynamic> myPosts;
    String displayName;
    String uid;

    // for users that saved deleted recipe
   db.usersCollection
        .where('saved', arrayContains: docId).snapshots().listen((
        QuerySnapshot snapshot) {
     saved = snapshot.docs[0]['saved'];
     userDocID = snapshot.docs[0].reference.id;
     myPosts = snapshot.docs[0]['myPosts'];
     displayName = snapshot.docs[0]['displayName'];
     uid = snapshot.docs[0]['uid'];

     //remove deleted recipe from saved
     saved.remove(docId);

     //update user
     db.usersCollection.doc(userDocID).update({
       'displayName': displayName,
       'myPosts': myPosts,
       'saved': saved,
       'uid': uid
     });
   });

      // for users that post deleted recipe
      db.usersCollection
        .where('myPosts', arrayContains: docId).snapshots().listen((
        QuerySnapshot snapshot) {
      saved = snapshot.docs[0]['saved'];
      userDocID = snapshot.docs[0].reference.id;
      myPosts = snapshot.docs[0]['myPosts'];
      displayName = snapshot.docs[0]['displayName'];
      uid = snapshot.docs[0]['uid'];

      //remove deleted recipe from myPosts
      myPosts.remove(docId);

      //update user
      db.usersCollection.doc(userDocID).update({
        'displayName': displayName,
        'myPosts': myPosts,
        'saved': saved,
        'uid': uid
      });
    });
  }
}

    //   usersThatSavedRecipe.forEach((QuerySnapshot snapshot) =>
    //   {
    //     saved = snapshot['sa,
    //     userDocID = snapshot.docs.reference.id,
    //     myPosts = snapshot.docs['myPosts'],
    //     displayName = snapshot.docs['displayName'],
    //     uid = snapshot.docs['uid'],
    //
    //     //remove deleted recipe from saved
    //     saved.remove(docId),
    //     print(saved),
    //
    //     //update user
    //     db.usersCollection.doc(userDocID).update({
    //       'displayName': displayName,
    //       'myPosts': myPosts,
    //       'saved': saved,
    //       'uid': uid
    //     })
    //   });
    // }

