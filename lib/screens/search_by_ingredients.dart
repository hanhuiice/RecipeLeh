import 'package:flutter/material.dart';


class searchByIngredients extends StatefulWidget {
  const searchByIngredients({Key key}) : super(key: key);

  @override
  _searchByIngredientsState createState() => _searchByIngredientsState();
}

class _searchByIngredientsState extends State<searchByIngredients> {
  List<DynamicWidget> listDynamic = [];
  List<String> data = [];

  Icon floatingIcon = new Icon(Icons.add);

  addDynamic() {
    if (data.length != 0) {
      floatingIcon = new Icon(Icons.add);
      data = [];
      listDynamic = [];
    }
    setState(() {});
    listDynamic.add(new DynamicWidget());
  }

  submitData() {
    floatingIcon = new Icon(Icons.arrow_back);
    data = [];
    listDynamic.forEach((widget) => data.add(widget.controller.text));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget result = new Flexible(
        flex: 1,
        child: new Card(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              return new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: new EdgeInsets.only(left: 10.0),
                      child: new Text("${index + 1} : ${data[index]}"),
                    ),
                    new Divider()
                  ],
                ),
              );
            },
          ),
        ));

    Widget dynamicTextField = new Flexible(
      flex: 2,
      child: new ListView.builder(
        itemCount: listDynamic.length,
        itemBuilder: (_, index) => listDynamic[index],
      ),
    );

    Widget submitButton = new Container(
      child: new ElevatedButton(
        onPressed: submitData,
        child: new Padding(
          padding: new EdgeInsets.all(16.0),
          child: new Text('Search'),
        ),
      ),
    );

    return Scaffold(
        appBar: new AppBar(
          title: new Text('Search By Ingredients'),
        ),
        body: new Container(
          margin: new EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[
              data.length == 0 ? dynamicTextField : result,
              data.length == 0 ? submitButton : new Container(),
            ],
          ),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: addDynamic,
          child: floatingIcon,
        ),
      );
  }
}

class DynamicWidget extends StatelessWidget {
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(8.0),
      child: new TextField(
        controller: controller,
        decoration: new InputDecoration(hintText: 'Enter Ingredient '),
      ),
    );
  }
}