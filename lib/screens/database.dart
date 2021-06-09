import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference recipeCollection = FirebaseFirestore.instance.collection('recipe');

  addRecipe(String uid, String name, List<String> ingredients, String instructions, String image) {
    recipeCollection.add({
      'uid' : uid,
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
      'image': image,
    });
  }

  Stream<QuerySnapshot> get recipes {
    return recipeCollection.snapshots();

  }

  Future recipeList() async {
    List itemsList = [];

    try {
      await recipeCollection.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }



  myRecipe(String uid) {

  }
}