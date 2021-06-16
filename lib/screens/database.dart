import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference recipeCollection = FirebaseFirestore.instance.collection('recipe');
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

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
      'likes': [],
    });
  }

  addComment(String uid, String displayName, String postID, String comment) {
    final CollectionReference commentsCollection = recipeCollection.doc(postID).collection('comments');
    commentsCollection.add({
      'uid' : uid,
      'displayName': displayName,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  addUser(String uid, String displayName) {
    usersCollection.add({
      'uid' : uid,
      'displayName' : displayName,
      'myPosts': [],
      'saved' : []
    });
  }

  Stream<QuerySnapshot> get recipes {
    return recipeCollection.snapshots();
  }

  Stream<QuerySnapshot> get users {
    return usersCollection.snapshots();
  }


  Stream<QuerySnapshot> comments(String postID) {
    return recipeCollection.doc(postID).collection('comments').snapshots();
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



}
