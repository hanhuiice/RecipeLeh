import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../classes/recipe.dart';
import 'recipe_details.dart';
import '../hardcode_recipes.dart'; //hardcode recipes


class displayRecipes extends StatefulWidget {
  String name;
  List<recipe> recipes;
  displayRecipes({Key key, this.name, this.recipes}) : super(key: key);


  @override
  _displayRecipes createState() => _displayRecipes();
}

class _displayRecipes extends State<displayRecipes> {

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
        appBar: AppBar(title: Text(widget.name)),
        body: ListView.builder(
          itemCount: widget.recipes.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => recipeDetails(widget.recipes[index])));
                },
                title: Text(widget.recipes[index].recipeName),
                subtitle: Text("Number of likes "),
              )
            );
          },
        )
    );
  }
}


