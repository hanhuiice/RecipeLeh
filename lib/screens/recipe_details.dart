import 'package:flutter/material.dart';

import '../recipe.dart';

class recipeDetails extends StatefulWidget {
  final recipe selectedRecipe;

  recipeDetails(this.selectedRecipe);

  // const recipeDetails({Key key, this.selectedRecipe}) : super(key: key);

  @override
  _recipeDetailsState createState() => _recipeDetailsState();
}

class _recipeDetailsState extends State<recipeDetails> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.selectedRecipe.user);
  }
}
