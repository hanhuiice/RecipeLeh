import 'package:flutter/material.dart';

class myPosts extends StatefulWidget {
  const myPosts({Key key}) : super(key: key);

  @override
  _myPostsState createState() => _myPostsState();
}

class _myPostsState extends State<myPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("My Posts")),
        body: Text("My Posts")
    );
  }
}
