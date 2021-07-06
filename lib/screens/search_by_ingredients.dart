import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'display_recipes.dart';
import 'database.dart';

class searchByIngredients extends StatefulWidget {
  final User user;

  searchByIngredients({Key key, this.user}) : super(key: key);

  @override
  _searchByIngredientsState createState() => _searchByIngredientsState();
}

class _searchByIngredientsState extends State<searchByIngredients> {
  final _formKey = GlobalKey<FormState>();
  static List<String> ingredients;
  final DatabaseService db = DatabaseService();
  List<String> copyOfIngredients;

  @override
  void initState() {
    super.initState();
    ingredients = [null];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Search By Ingredients'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name textfield
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Add Ingredients',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  ..._getIngredients().reversed,
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () => {
                        if (_formKey.currentState.validate())
                              {
                                copyOfIngredients = getSearchIngredient(ingredients),
                      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => displayRecipes(
                                            user: widget.user,
                                            title: "Results",
                                            recipes: search(),
                                            ingredientList: copyOfIngredients))),
                                setState(() {})
                              }
                          },
                      child: Text('Search'),
                      style: ElevatedButton.styleFrom(primary: Colors.green)),
                ],
              ),
            ),
          ),
        ));
  }

  /// get ingredients text-fields
  List<Widget> _getIngredients() {
    List<Widget> ingredientsTextField = [];
    for (int i = 0; i < ingredients.length; i++) {
      ingredientsTextField.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: IngredientsTextField(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == 0, i),
          ],
        ),
      ));
    }
    return ingredientsTextField;
  }

  Stream search() {
    List<String> searchIngredient = getSearchIngredient(ingredients);
    Stream res;
    if (!ingredients.contains(null)) {
      res = db.recipeCollection
          .where('ingredients', arrayContainsAny: searchIngredient)
          .snapshots();
    }
    ingredients = [null];
    return res;
  }

  List<String> getSearchIngredient(List<String> list) {
    for (int i = 0; i < list.length; i++) {
      list[i] = list[i].substring(0, 1).toUpperCase() + (list[i].substring(1, list[i].length)).toLowerCase();
    }
    return list;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          ingredients.insert(0, null);
        } else
          ingredients.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class IngredientsTextField extends StatefulWidget {
  final int index;

  IngredientsTextField(this.index);

  @override
  _IngredientsTextFieldsState createState() => _IngredientsTextFieldsState();
}

class _IngredientsTextFieldsState extends State<IngredientsTextField> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text =
          _searchByIngredientsState.ingredients[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameController,
      onChanged: (v) => _searchByIngredientsState.ingredients[widget.index] = v,
      decoration: InputDecoration(hintText: 'Enter your ingredient'),
      validator: (v) {
        if (v.trim().isEmpty) return 'Please enter something or remove this if not needed';
        return null;
      },
    );
  }
}
