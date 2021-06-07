import 'package:flutter/material.dart';

typedef OnDelete();

class ingredientForm extends StatefulWidget {
  String ingredient;
  final state = _ingredientFormState();
  final OnDelete onDelete;

  ingredientForm({Key key, this.ingredient, this.onDelete}) : super(key: key);
  @override
  _ingredientFormState createState() => state;

  bool isValid() => state.validate();
}

class _ingredientFormState extends State<ingredientForm> {
  final form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Material(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                leading: Icon(Icons.verified_user),
                elevation: 0,
                title: Text('User Details'),
                backgroundColor: Theme.of(context).accentColor,
                centerTitle: true,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: TextFormField(
                  initialValue: widget.ingredient,
                  onSaved: (val) => widget.ingredient = val,
                  validator: (val) =>
                  val.length > 3 ? null : 'Ingredient is invalid',
                  decoration: InputDecoration(
                    labelText: 'Ingredient',
                    hintText: 'Enter Ingredient',
                    icon: Icon(Icons.fastfood),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///form validator
  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    return valid;
  }
}