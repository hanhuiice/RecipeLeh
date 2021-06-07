import 'package:flutter/material.dart';
import 'package:recipe_leh/screens/database.dart';

class RecipeUpload extends StatefulWidget {
  const RecipeUpload({Key key}) : super(key: key);

  @override
  _RecipeUploadState createState() => _RecipeUploadState();
}

class _RecipeUploadState extends State<RecipeUpload> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  DatabaseService databaseService = DatabaseService();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sign Up")),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Enter Recipe Name",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Recipe Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                        }
                        (await databaseService.addRecipe(nameController.text)).then({
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (BuildContext context) => super.widget))
                        });
                      },
                      child: Text('Post'),
                    ),
                  )
                ]))));
  }
}

