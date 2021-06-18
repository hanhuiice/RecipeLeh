import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_leh/screens/database.dart';
import 'package:path/path.dart';

class EditForm extends StatefulWidget {
  final User user;
  final DocumentSnapshot selectedRecipe;
  EditForm({this.user, this.selectedRecipe});

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController;
  TextEditingController instructionController;
  static List<dynamic> ingredientsList;
  bool isLoading = false;
  DatabaseService databaseService = DatabaseService();
  File imageFile;
  String link;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.selectedRecipe['name']);
    instructionController = TextEditingController(text: widget.selectedRecipe['instructions']);
    ingredientsList = widget.selectedRecipe['ingredients'];
    ingredientsList = ingredientsList.reversed.toList();
    link = widget.selectedRecipe['image'];
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    instructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text("Edit"),),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: 'Enter your recipe name'
                    ),
                    validator: (value){
                      if(value.isEmpty) return 'Please enter something';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Text('Add ingredients', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                ..._getIngredients().reversed,
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: TextFormField(
                    maxLines: null,
                    maxLength: null,
                    controller: instructionController,
                    decoration: InputDecoration(
                      labelText: 'Instructions',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value){
                      if(value.isEmpty) return 'Please enter something';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20,),
                Container(child: (imageFile == null)
                    ? (link == null)
                      ? Text("Image")
                      : Image.network(link)
                    : Image.file(imageFile),
                  alignment: Alignment.center,
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue)),
                  onPressed: () {
                    _showChoiceDialog(context);
                  },
                  child: Text('Select Image'),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      updateToFirebase();
                      setState(() {
                        ingredientsList = [null];
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Done'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getIngredients(){
    List<Widget> ingredientTextFields = [];
    for(int i=0; i<ingredientsList.length; i++){
      ingredientTextFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(child: IngredientTextFields(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButton(i == 0, i),
              ],
            ),
          )
      );
    }
    return ingredientTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          ingredientsList.insert(0, null);
        }
        else ingredientsList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }

  Future updateToFirebase() async {
    List<dynamic> list = _EditFormState.ingredientsList.reversed.toList();
    String docId = widget.selectedRecipe.id;
    if (imageFile != null) {
      String fileName = basename(imageFile.path);
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('uploads/$fileName');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() => null);
      storageReference.getDownloadURL().then((fileURL) {
        databaseService.recipeCollection.doc(docId).update({
          'name': nameController.text,
          'ingredients': list,
          'instructions': instructionController.text,
          'image': fileURL,
        });
      });
    } else {
      databaseService.recipeCollection.doc(docId).update({
        'name': nameController.text,
        'ingredients': list,
        'instructions': instructionController.text,
      });
    }
  }

  Future _showChoiceDialog(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  _openGallery(context);
                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  _openCamera(context);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }

  void _openCamera(BuildContext context) async{
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera ,
    );
    setState(() {
      imageFile = File(pickedFile.path);
    });
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async{
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery ,
    );
    setState(() {
      imageFile = File(pickedFile.path);
    });

    Navigator.pop(context);
  }
}

class IngredientTextFields extends StatefulWidget {
  final int index;
  IngredientTextFields(this.index);
  @override
  _IngredientTextFieldsState createState() => _IngredientTextFieldsState();
}

class _IngredientTextFieldsState extends State<IngredientTextFields> {
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      nameController.text = _EditFormState.ingredientsList[widget.index] ?? '';
    });

    return TextFormField(
      controller: nameController,
      onChanged: (value) => _EditFormState.ingredientsList[widget.index] = value,
      decoration: InputDecoration(
          labelText: 'Enter the ingredients'
      ),
      validator: (value){
        if(value.isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}

