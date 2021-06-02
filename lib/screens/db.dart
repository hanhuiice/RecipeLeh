import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Database extends StatelessWidget {
  const Database({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('test'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => FirebaseFirestore.instance
                .collection('testing')
                .add({'name': "Joseph"}),
            child: Icon(Icons.add),
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("testing").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  final docData = snapshot.data.docs[index]['name'];
                  return ListTile(
                    title: Text(docData.toString() + index.toString()),
                  );
                },
              );
            },
          )
      );
  }
}