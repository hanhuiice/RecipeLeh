import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../1/post.dart';

class ViewPostScreen extends StatefulWidget {
  final DocumentSnapshot selectedRecipe;
  final User user;

  ViewPostScreen({Key key, this.selectedRecipe, this.user}) : super(key: key);

  @override
  _ViewPostScreenState createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  Post post;
  bool isSameUser;

  @override
  void initState() {
    super.initState();
    post = posts[0];
    isSameUser = widget.user.uid == widget.selectedRecipe['uid'];
    // }
  }

  @override
  Widget build(BuildContext context) {
    String ingredients = "";

    for (String ingredient in widget.selectedRecipe['ingredients']) {
      ingredients += ingredient + ", ";
    }
    ingredients = ingredients.substring(0, ingredients.length - 2);

    List<String> instructionsList =
        widget.selectedRecipe['instructions'].split("\n");
    String instructions = "";
    int counter = 1;
    for (String instruction in instructionsList) {
      String merger = "Step " + counter.toString() + ": ";
      counter += 1;
      instructions += merger + instruction + "\n\n";
    }

    print(widget.selectedRecipe.reference.id);

    return Scaffold(
      // backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Post'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            // padding: EdgeInsets.only(top: 10.0),
            width: double.infinity,
            // height: 700.0,
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: ListTile(
                                  title: Text(
                                    widget.selectedRecipe['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text("Time ago?"),
                                  trailing: isSameUser
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                              IconButton(
                                                  icon: Icon(Icons.edit,
                                                      color: Colors.black),
                                                  onPressed: () => {
                                                        print('edit'),
                                                      }),
                                              IconButton(
                                                  icon: Icon(Icons.delete,
                                                      color: Colors.black),
                                                  onPressed: () =>
                                                      {print('delete')})
                                            ])
                                      : null))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                        width: double.infinity,
                        height: 500.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 5),
                              blurRadius: 8.0,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                                // mainAxisAlignment:
                                // MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  if (widget.selectedRecipe['image'] != null)
                                    Image.network(
                                      widget.selectedRecipe['image'],
                                      height: 250.0,
                                    ),
                                  if (widget.selectedRecipe['image'] == null)
                                    Image.asset('assets/images/dart.png',
                                        height: 250.0, width: 350.0),
                                  SizedBox(height: 10.0),
                                  Text('Name:',
                                      style: TextStyle(
                                          // fontWeight: FontWeight.w700,
                                          fontSize: 16)),
                                  Text(widget.selectedRecipe['name'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16)),
                                  SizedBox(height: 10.0),
                                  Text('Ingredients:',
                                      style: TextStyle(
                                          // fontWeight: FontWeight.w700,
                                          fontSize: 16)),
                                  Text(ingredients,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16)),
                                  SizedBox(height: 10.0),
                                  Text('Instructions:',
                                      style: TextStyle(
                                          // fontWeight: FontWeight.w700,
                                          fontSize: 16)),
                                  Text(instructions,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16))
                                ])),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.favorite_border),
                                      iconSize: 30.0,
                                      onPressed: () => print('Like post'),
                                    ),
                                    Text(
                                      'Fuck you',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.0),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.chat),
                                      iconSize: 30.0,
                                      onPressed: () {
                                        print('Chat');
                                      },
                                    ),
                                    Text(
                                      'HanHui',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.bookmark_border),
                              iconSize: 30.0,
                              onPressed: () => print('Save post'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 10.0),
          // Container(
          //   width: double.infinity,
          //   height: 600.0,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(30.0),
          //       topRight: Radius.circular(30.0),
          //     ),
          //   ),
          //   child: Column(
          //     children: <Widget>[
          //       _buildComment(0),
          //       _buildComment(1),
          //       _buildComment(2),
          //       _buildComment(3),
          //       _buildComment(4),
          //     ],
          //   ),
          // )
        ],
        // ),
      ),
      // bottomNavigationBar: Transform.translate(
      //   offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      //   child: Container(
      //     height: 100.0,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.only(
      //         topLeft: Radius.circular(30.0),
      //         topRight: Radius.circular(30.0),
      //       ),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.black12,
      //           offset: Offset(0, -2),
      //           blurRadius: 6.0,
      //         ),
      //       ],
      //       color: Colors.white,
      //     ),
      //     child: Padding(
      //       padding: EdgeInsets.all(12.0),
      //       child: TextField(
      //         decoration: InputDecoration(
      //           border: InputBorder.none,
      //           enabledBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(30.0),
      //             borderSide: BorderSide(color: Colors.grey),
      //           ),
      //           focusedBorder: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(30.0),
      //             borderSide: BorderSide(color: Colors.grey),
      //           ),
      //           contentPadding: EdgeInsets.all(20.0),
      //           hintText: 'Add a comment',
      //           prefixIcon: Container(
      //             margin: EdgeInsets.all(4.0),
      //             width: 48.0,
      //             height: 48.0,
      //             decoration: BoxDecoration(
      //               shape: BoxShape.circle,
      //               boxShadow: [
      //                 BoxShadow(
      //                   color: Colors.black45,
      //                   offset: Offset(0, 2),
      //                   blurRadius: 6.0,
      //                 ),
      //               ],
      //             ),
      //             child: CircleAvatar(
      //               child: ClipOval(
      //                 child: Image(
      //                   height: 48.0,
      //                   width: 48.0,
      //                   image: AssetImage(post.authorImageUrl),
      //                   fit: BoxFit.cover,
      //                 ),
      //               ),
      //             ),
      //           ),
      //           suffixIcon: Container(
      //             margin: EdgeInsets.only(right: 4.0),
      //             width: 70.0,
      //             child: FlatButton(
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(30.0),
      //               ),
      //               color: Color(0xFF23B66F),
      //               onPressed: () => print('Post comment'),
      //               child: Icon(
      //                 Icons.send,
      //                 size: 25.0,
      //                 color: Colors.white,
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
