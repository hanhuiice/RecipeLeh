import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_leh/classes/recipe.dart';

class DatabaseService {
  final CollectionReference recipeCollection = FirebaseFirestore.instance.collection('recipe');

  addRecipe(String name) {
    recipeCollection.add({
      'name': name,
    });
  }

  getRecipe() {
    return recipeCollection.snapshots();
  }

  myRecipe(String uid) {

  }
}