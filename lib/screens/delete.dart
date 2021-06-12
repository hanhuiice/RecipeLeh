import 'package:flutter/material.dart';
import 'package:recipe_leh/screens/database.dart';

class DeleteDialog {
  final String docId;
  final DatabaseService db = DatabaseService();

  DeleteDialog({this.docId});

  Future showDeleteDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Alert"),
        content: Text("Confirm to delete post?"),
        actions: [
          yesButton(context),
          noButton(context),
        ],);
    });
  }

  Widget noButton(BuildContext context) => TextButton(
    child: Text("NO"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  Widget yesButton(BuildContext context) => TextButton(
    child: Text("YES"),
    onPressed:  () {
      db.delete(docId);
      Navigator.of(context).pop();
      Navigator.pop(context);
    },
  );
}
