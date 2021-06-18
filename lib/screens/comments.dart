import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'database.dart';

class comments extends StatefulWidget {
  final DocumentSnapshot selectedRecipe;
  final User user;
  const comments({Key key, this.selectedRecipe, this.user}) : super(key: key);

  @override
  _commentsState createState() => _commentsState();
}

class _commentsState extends State<comments> {
  DatabaseService db = DatabaseService();

  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Comments')),
            body: Column(
              children: <Widget>[
                Expanded(
                  child:
                  StreamBuilder(
                      stream: db.comments(widget.selectedRecipe.id),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return
                            ListView.builder(
                              itemCount: snapshot.data.size,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                    child: ListTile(
                                      leading: Text(snapshot.data.docs[index]['displayName']),
                                      title: Text(snapshot.data.docs[index]['comment']),
                                      subtitle: Text((widget.selectedRecipe['timestamp'] as Timestamp).toDate().difference(DateTime.now()).inDays.toString()
                                          + " days ago"),
                                    ));
                              },
                            );
                        }
                      }
                  ),
                ),
                  Divider(),
                (widget.user.isAnonymous) ?
                    new Container()
                    :
                  ListTile(
                    title: TextFormField(
                      controller: commentController,
                      decoration: InputDecoration(labelText: "Write a comment ..."),
                    ),
                    trailing: OutlinedButton(
                      onPressed: () => {
                        print('posted'),
                        db.addComment(
                            widget.user.uid,
                            widget.user.displayName,
                            widget.selectedRecipe.id,
                            commentController.text),
                        commentController.clear()
                      },
                      child: Text("Post"),
                    ),
                  )
                ],
              ),
            );
        // ));
  }
}
