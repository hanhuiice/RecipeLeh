import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:recipe_leh/screens/db.dart';
import 'package:recipe_leh/extras/upload.dart';

import '../../extras/signup.dart';
import '../display_recipes.dart';
import '../email_login.dart';
import 'search_widget.dart';
import '../../classes/recipe.dart'; //recipe class
import '../recipe_details.dart';
import '../../hardcode_recipes.dart'; //hardcode recipes
import '../search_by_ingredients.dart';


class searchByRecipeName extends StatefulWidget {
  searchByRecipeName({this.uid});

  final String uid;

  @override
  _searchByRecipeNameState createState() => _searchByRecipeNameState();
}

class _searchByRecipeNameState extends State<searchByRecipeName> {
  final String title = "Search By Name Of Recipe";

  String query = '';
  List<recipe> recipes;


  @override
  void initState() {
    super.initState();
    recipes = hardcode;
  }

  @override
  Widget build(BuildContext context) {
    //print(recipes);
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
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => recipeDetails(recipes[index])));
                        },
                        title: Text(recipes[index].recipeName),
                        subtitle: Text("Number of likes "),
                  )
                  );
                },
              ),
            ),
          ],
        ),
        drawer: NavigateDrawer(uid: this.widget.uid, saved: recipes, posts: recipes));
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Name of Recipe',
        onChanged: searchRecipe,
      );

  void searchRecipe(String query) {
    final recipes = hardcode.where((recipe) {
      final recipeNameLower = recipe.recipeName.toLowerCase();
      final searchLower = query.toLowerCase();

      return recipeNameLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.recipes = recipes;
    });
  }
}

class NavigateDrawer extends StatefulWidget {
  final String uid;
  List<recipe> saved;
  List<recipe> posts;

  NavigateDrawer({Key key, this.uid, this.saved, this.posts}) : super(key: key);

  @override
  _NavigateDrawerState createState() => _NavigateDrawerState();
}

class _NavigateDrawerState extends State<NavigateDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountEmail: FutureBuilder(
                future: FirebaseDatabase.instance
                    .reference()
                    .child("Users")
                    .child(widget.uid)
                    .once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.value['email']);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
            accountName: FutureBuilder(
                future: FirebaseDatabase.instance
                    .reference()
                    .child("Users")
                    .child(widget.uid)
                    .once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.value['name']);
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
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
                              searchByRecipeName(uid: widget.uid)),
                    )),
            title: Text('Search By Name Of Recipe'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => searchByRecipeName(uid: widget.uid)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
                icon: new Icon(Icons.checklist, color: Colors.black),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => searchByIngredients()),
                    )),
            title: Text('Search By Ingredients'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => searchByIngredients()),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
                icon: new Icon(Icons.favorite, color: Colors.black),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => displayRecipes(name: "Saved Recipes", recipes: widget.saved)),
                    )),
            title: Text('Saved Recipes'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => displayRecipes(name: "Saved Recipes ", recipes: widget.saved)),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
                icon: new Icon(Icons.create, color: Colors.black),
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadForm()),
                    )),
            title: Text('Upload'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadForm()),
              );
            },
          ),
          ListTile(
            leading: new IconButton(
                icon: new Icon(Icons.account_circle, color: Colors.black),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => displayRecipes(name: "My Posts", recipes: widget.posts)),
                )),
            title: Text('My Posts'),
            onTap: () {
              print(widget.uid);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => displayRecipes(name: "My Posts", recipes: widget.posts)),
              );
            },
          ),
        ],
      ),
    );
  }
}
