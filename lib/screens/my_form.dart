import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../classes/recipe.dart';
import '../hardcode_recipes.dart';
import 'saved_recipes.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  static List<String> ingredients = [null];
  List<recipe> recipes = hardcode;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text('Dynamic TextFormFields'),),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name textfield
              SizedBox(height: 20,),
              Text('Add Ingredients', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
              ..._getIngredients(),
              SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () => {
                  if(_formKey.currentState.validate()){
                    search(),
                    Navigator.push(
                        context,
                    MaterialPageRoute(builder: (context) => savedRecipes(name: "Results", recipes: recipes)))
                    // _formKey.currentState.save();
                  }
                },
                child: Text('Search'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green
                )
              ),

            ],
          ),
        ),
      ),

    );
  }

  /// get ingredients text-fields
  List<Widget> _getIngredients(){
    List<Widget> ingredientsTextField = [];
    for(int i=0; i<ingredients.length; i++){
      ingredientsTextField.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(child: IngredientsTextField(i)),
                SizedBox(width: 16,),
                // we need add button at last friends row
                _addRemoveButton(i == ingredients.length-1, i),
              ],
            ),
          )
      );
    }
    return ingredientsTextField;
  }

  search() {
    var recipeStream = new Stream.fromIterable(recipes);
    for (int i = 0; i < ingredients.length; i++) {
      // print(recipeStream.every(c -> c.user == ingredients[i]));

      print(ingredients[i]);
    }
     ingredients = [null];

  }




  /// add / remove button
  Widget _addRemoveButton(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          ingredients.insert(0, null);
        }
        else ingredients.removeAt(index);
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
      _nameController.text = _MyFormState.ingredients[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameController,
      onChanged: (v) => _MyFormState.ingredients[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Enter your ingredient'
      ),
      validator: (v){
        if(v.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}