import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'viewPostScreen/view_post_screen.dart';
import 'database.dart';

class displayRecipes extends StatefulWidget {
  User user;
  String title;
  Stream<QuerySnapshot> recipes;
  List<dynamic> ingredientList;
  // to check whether users is at myPosts or savedRecipes
  bool isMyPosts;

  displayRecipes({Key key, this.title, this.user, this.recipes, this.ingredientList, this.isMyPosts})
      : super(key: key);

  @override
  _displayRecipes createState() => _displayRecipes();
}

class _displayRecipes extends State<displayRecipes> {
  final DatabaseService db = DatabaseService();

  // have to initialise bcos it returns a future value
  List<dynamic> savedList = [];


  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    //get saved list
    await db.usersCollection
        .where('uid', isEqualTo: widget.user.uid)
        .get()
        .then((QuerySnapshot snapshot) => {
      setState(() => {
        savedList = snapshot.docs[0]['saved'],
      })
    });
  }

  Stream<QuerySnapshot> getMyPosts() {
    return db.recipeCollection
        .where('uid', isEqualTo: widget.user.uid)
        .snapshots();
  }

  getSaved() {
    //using saved list find all the recipes
    Stream<QuerySnapshot> saved;
    db.usersCollection
        .where('uid', isEqualTo: widget.user.uid)
        .get()
        .then((QuerySnapshot snapshot) => {
      savedList = snapshot.docs[0]['saved'],
    });

    if (savedList.isEmpty) {
      saved = db.recipeCollection
          .where('docID', arrayContains: []).snapshots();
    } else {
      saved = db.recipeCollection
          .where('docID', arrayContainsAny: savedList)
          .snapshots();
    }
    return saved;
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
            stream: (widget.recipes == null ? widget.isMyPosts ? getMyPosts() : getSaved() : widget.recipes),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data.size == 0) {
                return Center(
                    child: Text('Recipes not found.')
                );
              }
              else {
                List<QueryDocumentSnapshot> c = snapshot.data.docs;
                List<Matches> result = [];
                if (widget.ingredientList != null) {
                  c.forEach((element) {
                    int count = 0;
                    List<dynamic> matchingIngredients = [];
                    List<dynamic> list = element.get('ingredients');
                    widget.ingredientList.forEach((element) {
                      if(list.contains(element)) {
                        count++;
                        matchingIngredients.add(element);
                      }
                    });
                    result.add(Matches(element, matchingIngredients.toSet().toList(), count));
                  });
                  result.sort((a,b) {
                    return b.count - a.count;
                  });
                } else {
                  c.forEach((element) {
                    result.add(Matches(element, [], 0));
                  });
                }
                return ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (BuildContext context, int index)  {
                  return Card(
                      child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewPostScreen(
                                  user: widget.user,
                                  selectedRecipe: result[index].documentSnapshot))).then((value) => db.usersCollection
                          .where('uid', isEqualTo: widget.user.uid)
                          .get()
                          .then((QuerySnapshot snapshot) => {
                        setState(() => {
                          savedList = snapshot.docs[0]['saved'],
                        })
                      }));
                    },
                    title: Text(result[index].documentSnapshot['name']),
                    subtitle: (widget.recipes != null) ? Text("Matching Ingredients: " + result[index].matchingIngredients.toString())
                                                       : Text("Number of likes: " + (result[index].documentSnapshot['likes'] as List).length.toString()),
                  ));
                },
              );}
                }),
        );

  }
}

class Matches {
  DocumentSnapshot documentSnapshot;
  int count;
  List<dynamic> matchingIngredients;

  Matches(this.documentSnapshot, this.matchingIngredients, this.count);
}
