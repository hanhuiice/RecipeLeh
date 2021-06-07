import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_leh/classes/recipe.dart';

class DatabaseService {
  final CollectionReference recipeCollection = FirebaseFirestore.instance.collection('recipe');

  addRecipe(String name, List<String> ingredients, String instructions) {
    recipeCollection.add({
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
    });
  }

  getRecipe() {
    return recipeCollection.snapshots();
  }

  myRecipe(String uid) {

  }
}