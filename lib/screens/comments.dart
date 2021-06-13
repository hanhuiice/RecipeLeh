import 'package:flutter/material.dart';

class comments extends StatefulWidget {
  const comments({Key key}) : super(key: key);

  @override
  _commentsState createState() => _commentsState();
}

class _commentsState extends State<comments> {
  TextEditingController commentController = TextEditingController();

  buildComments() {
    return Text("Comment",
    textAlign: TextAlign.center,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments')),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText:  "Write a comment ..."),
            ),
            trailing: OutlinedButton(
              onPressed: () => print('add a comment'),
              child: Text("Post"),
            ),
          )
        ],
      )
    );
  }
}
