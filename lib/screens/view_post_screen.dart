import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_leh/screens/delete.dart';
import 'package:recipe_leh/screens/edit.dart';
import 'comments.dart';

import '../1/post.dart';
import 'database.dart';

class ViewPostScreen extends StatefulWidget {
  final DocumentSnapshot selectedRecipe;
  final User user;

  ViewPostScreen({Key key, this.selectedRecipe, this.user}) : super(key: key);

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  DatabaseService db = DatabaseService();
  bool isSameUser;
  bool isSaved = false;
  bool isLiked = false;

  @override
  void initState() {
    isSameUser = widget.user.uid == widget.selectedRecipe['uid'];
    isLiked = (widget.selectedRecipe['likes'] as List).contains(widget.user.uid);
    List<dynamic> saved = [];
    db.usersCollection
        .where('uid', isEqualTo: widget.user.uid)
        .get()
        .then((QuerySnapshot snapshot) => {
              saved = snapshot.docs[0]['saved'],
              setState(() {
                isSaved = (saved.isNotEmpty && saved.contains(widget.selectedRecipe.id));
              })
            });
    super.initState();
  }

  saveOrUnsave(String recipeUID) async {
    List<dynamic> saved = [];
    String docID;
    List<dynamic> myPosts;
    String displayName;
    String uid;

    await db.usersCollection
        .where('uid', isEqualTo: widget.user.uid)
        .get()
        .then((QuerySnapshot snapshot) => {
              saved = snapshot.docs[0]['saved'],
              docID = snapshot.docs[0].reference.id,
              myPosts = snapshot.docs[0]['myPosts'],
              displayName = snapshot.docs[0]['displayName'],
              uid = snapshot.docs[0]['uid'],
            });

    if (isSaved) {
      saved.remove(recipeUID);
      setState(() {
        isSaved = false;
      });
    } else {
      saved.add(recipeUID);
      setState(() {
        isSaved = true;
      });
    }
    db.usersCollection.doc(docID).update({
      'displayName': displayName,
      'myPosts': myPosts,
      'saved': saved,
      'uid': uid
    });
  }

  like() async {
    List<dynamic> likes = (await db.recipeCollection.doc(widget.selectedRecipe.id).get())['likes'];
    if (isLiked) {
      likes.remove(widget.user.uid);
      setState(() {
        isLiked = false;
      });
    } else {
      likes.add(widget.user.uid);
      setState(() {
        isLiked = true;
      });
    }
    db.recipeCollection.doc(widget.selectedRecipe.id).update({
      'likes': likes,
    });
  }

  @override
  Widget build(BuildContext context) {

    String ingredients = "";

    for (String ingredient in widget.selectedRecipe['ingredients']) {
      ingredients += ingredient + ", ";
    }
    ingredients = ingredients.substring(0, ingredients.length - 2);

    List<String> instructionsList =
        widget.selectedRecipe['instructions'].split("\n");
    String instructions = "";
    int counter = 1;
    for (String instruction in instructionsList) {
      String merger = "Step " + counter.toString() + ": ";
      counter += 1;
      instructions += merger + instruction + "\n\n";
    }

    return Scaffold(
        // backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Post'),
        ),
        body: Container(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                // padding: EdgeInsets.only(top: 10.0),
                width: double.infinity,
                // height: 700.0,
                decoration: BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                      title: Text(
                                        widget.selectedRecipe['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text((widget.selectedRecipe['timestamp'] as Timestamp).toDate().difference(DateTime.now()).inDays.toString()
                                      + " days ago"),
                                      trailing: isSameUser
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                  IconButton(
                                                    icon: Icon(Icons.edit,
                                                        color: Colors.black),
                                                    onPressed: () =>
                                                        Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditForm(
                                                                user:
                                                                    widget.user,
                                                                selectedRecipe:
                                                                    widget
                                                                        .selectedRecipe,
                                                              )),
                                                    ),
                                                  ),
                                                  IconButton(
                                                      icon: Icon(Icons.delete,
                                                          color: Colors.black),
                                                      onPressed: () => {
                                                            DeleteDialog(
                                                                    docId: widget
                                                                        .selectedRecipe
                                                                        .id)
                                                                .showDeleteDialog(
                                                                    context)
                                                          })
                                                ])
                                          : null))
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                            width: double.infinity,
                            height: 500.0,
                            // color: Colors.black,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 5),
                                  blurRadius: 8.0,
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                    // mainAxisAlignment:
                                    // MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      if (widget.selectedRecipe['image'] !=
                                          null)
                                        Image.network(
                                          widget.selectedRecipe['image'],
                                          height: 250.0,
                                        ),
                                      if (widget.selectedRecipe['image'] ==
                                          null)
                                        Image.asset('assets/images/dart.png',
                                            height: 250.0, width: 350.0),
                                      SizedBox(height: 10.0),
                                      Text('Name:',
                                          style: TextStyle(
                                              // fontWeight: FontWeight.w700,
                                              fontSize: 16)),
                                      Text(widget.selectedRecipe['name'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16)),
                                      SizedBox(height: 10.0),
                                      Text('Ingredients:',
                                          style: TextStyle(
                                              // fontWeight: FontWeight.w700,
                                              fontSize: 16)),
                                      Text(ingredients,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16)),
                                      SizedBox(height: 10.0),
                                      Text('Instructions:',
                                          style: TextStyle(
                                              // fontWeight: FontWeight.w700,
                                              fontSize: 16)),
                                      Text(instructions,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16))
                                    ])),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon((isLiked) ? Icons.favorite : Icons.favorite_border),
                                          iconSize: 30.0,
                                          onPressed: () => like(),
                                        ),
                                        Text(
                                          'Fuck you',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 20.0),
                                    Row(
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(Icons.chat),
                                            iconSize: 30.0,
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => comments(
                                                        user: widget.user,
                                                        selectedRecipe: widget
                                                            .selectedRecipe)))),
                                        Text(
                                          'HanHui',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                isSaved
                                    ? IconButton(
                                        icon: Icon(Icons.bookmark),
                                        iconSize: 30.0,
                                        onPressed: () => {
                                              saveOrUnsave(widget
                                                  .selectedRecipe.reference.id)
                                            })
                                    : IconButton(
                                        icon: Icon(Icons.bookmark_border),
                                        iconSize: 30.0,
                                        onPressed: () => {
                                              saveOrUnsave(widget
                                                  .selectedRecipe.reference.id)
                                            }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
