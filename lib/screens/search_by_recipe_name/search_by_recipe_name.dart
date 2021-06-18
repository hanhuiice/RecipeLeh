import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe_leh/screens/view_post_screen.dart';
import 'package:recipe_leh/extras/upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import '../display_recipes.dart';
import '../email_login.dart';
import 'search_widget.dart';
import '../search_by_ingredients.dart';
import '../email_signup.dart';
import '../view_post_screen.dart';
import '../database.dart';

class searchByRecipeName extends StatefulWidget {
  searchByRecipeName({Key key, this.user}) : super(key: key);

  final User user;

  @override
  _searchByRecipeNameState createState() => _searchByRecipeNameState();
}

class _searchByRecipeNameState extends State<searchByRecipeName> {
  final String title = "Search By Name Of Recipe";
  final DatabaseService db = DatabaseService();
  String query = '';
  List recipes;

  // List recipes = ['123', '456'];
  // List<dynamic> hardcode = ['123', '456'];
  Stream<QuerySnapshot> recipeStream;

  Timer debouncer;

  @override
  void initState() {
    super.initState();

    recipeStream = db.recipes;
    //init();
  }

  @override
  void dispose() {
    debouncer.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final recipes = await db.recipeCollection
        .where(('name').toLowerCase(), isEqualTo: query)
        .snapshots()
        .toList();

    final recipeStream = db.recipeCollection
        .where(('name').toLowerCase(), isEqualTo: query)
        .snapshots();

    setState(() {
      this.recipes = recipes;
      this.recipeStream = recipeStream;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((res) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => EmailLogIn()),
                      (Route<dynamic> route) => false);
                });
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: StreamBuilder(
                  stream: recipeStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<QueryDocumentSnapshot> c = snapshot.data.docs;
                      c.sort((a, b){
                        return (b.get('likes') as List).length.compareTo((a.get('likes') as List).length);
                      });
                      return ListView.builder(
                        itemCount: c.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                              child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewPostScreen(
                                          user: widget.user,
                                          selectedRecipe:
                                              c[index])));
                            },
                            title: Text(c[index]['name']),
                            subtitle: Text("Number of likes: " + (c[index]['likes'] as List).length.toString()),
                          ));
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
        drawer: NavigateDrawer(user: this.widget.user, db: db));
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Name of Recipe',
        onChanged: searchRecipe,
      );

  void searchRecipe(String query) {
        print('here');
        Stream<QuerySnapshot> s = db.recipeCollection
            .where(('name').toLowerCase(), isEqualTo: query)
            .snapshots();

        setState(() {
          this.query = query;
          this.recipeStream = s;
        });
      }
}

class NavigateDrawer extends StatefulWidget {
  final User user;
  DatabaseService db;

  NavigateDrawer({Key key, this.user, this.db}) : super(key: key);

  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  // have to initialise bcos it returns a future value
  List<dynamic> savedList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    //get saved list
    await widget.db.usersCollection
        .where('uid', isEqualTo: widget.user.uid)
        .get()
        .then((QuerySnapshot snapshot) =>
    {
      setState(() =>
      {
        savedList = snapshot.docs[0]['saved'],
      })});
  }


  Stream<QuerySnapshot> getMyPosts() {

    return widget.db.recipeCollection
        .where('uid', isEqualTo: widget.user.uid)
        .snapshots();
  }

  getSaved() {
    //using saved list find all the recipes
    Stream<QuerySnapshot> saved;
    print(savedList);
    widget.db.usersCollection
        .where('uid', isEqualTo: widget.user.uid)
        .get()
        .then((QuerySnapshot snapshot) => {
              savedList = snapshot.docs[0]['saved'],
              // print(savedList),
            });

    if (savedList.isEmpty) {
      saved = widget.db.recipeCollection
          .where('docID', arrayContains: []).snapshots();
    } else {
      saved = widget.db.recipeCollection
          .where('docID', arrayContainsAny: savedList)
          .snapshots();
    }
    return saved;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: widget.user.isAnonymous
                ? Text(widget.user.uid)
                : Text(widget.user.email),
            accountName: widget.user.isAnonymous
                ? Text('Guest')
                : Text(widget.user.displayName),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: new IconButton(
                icon: new Icon(Icons.search, color: Colors.black),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              searchByRecipeName(user: widget.user)),
                    )),
            title: Text('Search By Name Of Recipe'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        searchByRecipeName(user: widget.user)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
                icon: new Icon(Icons.checklist, color: Colors.black),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              searchByIngredients(user: widget.user)),
                    )),
            title: Text('Search By Ingredients'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        searchByIngredients(user: widget.user)),
              );
            },
          ),
          // saved recipes
          ListTile(
            leading: new IconButton(
                icon: new Icon(Icons.bookmark, color: Colors.black),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => displayRecipes(
                              user: widget.user,
                              title: "Saved Recipes",
                              recipes: getSaved())),
                    )),
            title: Text('Saved Recipes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => displayRecipes(
                        user: widget.user,
                        title: "Saved Recipes ",
                        recipes: getSaved())),
              );
            },
          ),
          widget.user.isAnonymous
              // sign up
              ? ListTile(
                  leading: new IconButton(
                      icon: new Icon(Icons.email, color: Colors.black),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailSignUp()))),
                  title: Text('Sign Up with Email'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EmailSignUp()));
                  })
              // upload
              : ListTile(
                  leading: new IconButton(
                      icon: new Icon(Icons.create, color: Colors.black),
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadForm(
                                      user: widget.user,
                                    )),
                          )),
                  title: Text('Upload'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadForm(
                                user: widget.user,
                              )),
                    );
                  },
                ),
          widget.user.isAnonymous
              // empty
              ? new Container()
              // my myPosts
              : ListTile(
                  leading: new IconButton(
                      icon: new Icon(Icons.account_circle, color: Colors.black),
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => displayRecipes(
                                    user: widget.user,
                                    title: "My Posts",
                                    recipes: getMyPosts())),
                          )),
                  title: Text('My Posts'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => displayRecipes(
                              user: widget.user,
                              title: "My Posts",
                              recipes: getMyPosts())),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
