import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:recipe_leh/screens/view_post_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'view_post_screen.dart';
import 'database.dart';

class displayRecipes extends StatefulWidget {
  User user;
  String title;

  displayRecipes({Key key, this.title, this.recipes, this.user})
      : super(key: key);

  @override
  _displayRecipes createState() => _displayRecipes();
}

class _displayRecipes extends State<displayRecipes> {
  final DatabaseService db = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

  Widget recipeTemplate(recipe) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(recipe.recipeName,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                )),
            SizedBox(height: 6.0),
            Text(recipe.user,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[800],
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: StreamBuilder(
            stream: widget.recipes,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else {
                return ListView.builder(
                  itemCount: snapshot.data.size,
                  itemBuilder: (BuildContext context, int index)  {
                  return Card(
                      child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewPostScreen(
                                  user: widget.user,
                                  selectedRecipe: snapshot.data.docs[index])));
                    },
                    title: Text(snapshot.data.docs[index]['name']),
                    subtitle: Text("Number of likes "),
                  ));
                },
              );}
            }));
  }
}
