import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../recipe.dart';
import 'recipe_details.dart';

class savedRecipes extends StatefulWidget {
  const savedRecipes({Key key}) : super(key: key);

  @override
  _savedRecipes createState() => _savedRecipes();
}

class _savedRecipes extends State<savedRecipes> {
  List<recipe> x = [
    recipe(user: "hanhui", recipeName: "dog"),
    recipe(user: "jo", recipeName: "cat"),
    recipe(user: "a", recipeName: "b"),
    recipe(user: "c", recipeName: "d"),
    recipe(user: "e", recipeName: "f"),
    recipe(user: "e", recipeName: "f"),
    recipe(user: "e", recipeName: "f"),
    recipe(user: "e", recipeName: "f"),
    recipe(user: "e", recipeName: "f"),
    recipe(user: "e", recipeName: "f"),
    recipe(user: "e", recipeName: "f"),
    recipe(user: "e", recipeName: "f"),
    recipe(user: "x", recipeName: "f"),
    recipe(user: "y", recipeName: "f"),
    recipe(user: "z", recipeName: "f"),

  ];

  Widget recipeTemplate(x) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(x.recipeName,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                )),
            SizedBox(height: 6.0),
            Text(x.user,
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
        appBar: AppBar(title: Text("Saved Recipes")),
        body: ListView.builder(
          itemCount: x.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => recipeDetails(x[index])));
                },
                title: Text(x[index].recipeName),
                subtitle: Text("Number of likes "),
              )
            );
          },
          // children: x.map((x) => recipeTemplate(x)).toList(),
          // onTa
        )
    );
  }
}


