import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:recipe_leh/screens/view_post_screen.dart';
import 'package:recipe_leh/screens/db.dart';
import 'package:recipe_leh/extras/upload.dart';

import '../display_recipes.dart';
import '../email_login.dart';
import 'search_widget.dart';
import '../../classes/recipe.dart'; //recipe class
import '../recipe_details.dart';
import '../../hardcode_recipes.dart'; //hardcode recipes
import '../search_by_ingredients.dart';
import '../email_signup.dart';
import '../view_post_screen.dart';


class searchByRecipeName extends StatefulWidget {
  searchByRecipeName({this.user});

  final User user;

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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewPostScreen(user: widget.user, selectedRecipe: recipes[index])));
                    },
                    title: Text(recipes[index].recipeName),
                    subtitle: Text("Number of likes "),
                  ));
                },
              ),
            ),
          ],
        ),
        drawer: NavigateDrawer(
            user: this.widget.user, saved: recipes, posts: recipes));
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
  final User user;
  List<recipe> saved;
  List<recipe> posts;

  NavigateDrawer({Key key, this.user, this.saved, this.posts})
      : super(key: key);

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
            accountEmail: widget.user.isAnonymous ? Text(widget.user.uid) : Text(widget.user.email),
            accountName: widget.user.isAnonymous ? Text('Guest') : Text(widget.user.displayName),
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
              print(widget.user);
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
                          builder: (context) => searchByIngredients()),
                    )),
            title: Text('Search By Ingredients'),
            onTap: () {
              print(widget.user);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => searchByIngredients()),
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
                              title: "Saved Recipes", recipes: widget.saved)),
                    )),
            title: Text('Saved Recipes'),
            onTap: () {
              print(widget.user);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => displayRecipes(
                        title: "Saved Recipes ", recipes: widget.saved)),
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
                    print(widget.user);
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
                                builder: (context) => UploadForm(user: widget.user,)),
                          )),
                  title: Text('Upload'),
                  onTap: () {
                    print(widget.user);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadForm(user: widget.user,)),
                    );
                  },
                ),
          widget.user.isAnonymous
              // empty
              ? new Container()
              // my posts
              : ListTile(
                  leading: new IconButton(
                      icon: new Icon(Icons.account_circle, color: Colors.black),
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => displayRecipes(
                                    title: "My Posts", recipes: widget.posts)),
                          )),
                  title: Text('My Posts'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => displayRecipes(
                              title: "My Posts", recipes: widget.posts)),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
