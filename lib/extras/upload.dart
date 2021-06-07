import 'package:flutter/material.dart';
import 'package:recipe_leh/screens/database.dart';

class UploadForm extends StatefulWidget {
  @override
  _UploadFormState createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController instructionController = TextEditingController();
  static List<String> ingredientsList = [null];
  bool isLoading = false;
  DatabaseService databaseService = DatabaseService();

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
      appBar: AppBar(title: Text('New post'),),
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
                ..._getIngredients(),
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
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      databaseService.addRecipe(nameController.text, _UploadFormState.ingredientsList, instructionController.text);
                      setState(() {
                        ingredientsList = [null];
                      });
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => super.widget));
                    }
                  },
                  child: Text('Post'),
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
                _addRemoveButton(i == ingredientsList.length-1, i),
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
      nameController.text = _UploadFormState.ingredientsList[widget.index] ?? '';
    });

    return TextFormField(
      controller: nameController,
      onChanged: (value) => _UploadFormState.ingredientsList[widget.index] = value,
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

