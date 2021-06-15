import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference recipeCollection = FirebaseFirestore.instance.collection('recipe');

  addRecipe(String uid, String name, List<dynamic> ingredients, String instructions, String image) {
    var newDocRef = recipeCollection.doc();
    newDocRef.set({
      'docId': newDocRef.id,
      'uid' : uid,
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
      'image': image,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> get recipes {
    return recipeCollection.snapshots();
  }

  delete(String docId){
    recipeCollection.doc(docId).delete();
  }

  Future<List> recipeList() async {
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

  Future<DocumentSnapshot<Object>> getDocument(String docID) async {
    return await recipeCollection.doc(docID).get();
  }


  myRecipe(String uid) {

  }
}
