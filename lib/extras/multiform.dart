import 'package:flutter/material.dart';
import 'empty_state.dart';
import 'ingredient_form.dart';

class MultiForm extends StatefulWidget {
  @override
  _MultiFormState createState() => _MultiFormState();
}

class _MultiFormState extends State<MultiForm> {
  List<ingredientForm> ingredients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .0,
        leading: Icon(
          Icons.wb_cloudy,
        ),
        title: Text('REGISTER USERS'),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Save'),
            onPressed: onSave,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF30C1FF),
              Color(0xFF2AA7DC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ingredients.length <= 0
            ? Center(
          child: EmptyState(
            title: 'Oops',
            message: 'Add form by tapping add button below',
          ),
        )
            : ListView.builder(
          addAutomaticKeepAlives: true,
          itemCount: ingredients.length,
          itemBuilder: (_, i) => ingredients[i],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAddForm,
        foregroundColor: Colors.white,
      ),
    );
  }

  ///on form ingredient deleted
  void onDelete(String _ingredient) {
    setState(() {
      var find = ingredients.firstWhere(
            (it) => it.ingredient == _ingredient,
        orElse: () => null,
      );
      if (find != null) ingredients.removeAt(ingredients.indexOf(find));
    });
  }

  ///on add form
  void onAddForm() {
    setState(() {
      String x = "";
      ingredients.add(ingredientForm(
        ingredient: x,
        onDelete: () => onDelete(x),
      ));
    });
  }

  ///on save forms
  void onSave() {
    if (ingredients.length > 0) {
      var allValid = true;
      ingredients.forEach((form) => allValid = allValid && form.isValid());
      if (allValid) {
        var data = ingredients.map((it) => it.ingredient).toList();
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text('List of Users'),
              ),
              body: ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, i) => ListTile(
                  leading: CircleAvatar(
                    child: Text(data[i].substring(0, 1)),
                  ),
                  title: Text(data[i]),
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}