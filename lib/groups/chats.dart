import 'package:agripreneur/groups/chat_app.dart';
import 'package:agripreneur/groups/create.dart';
import 'package:agripreneur/groups/join.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  String email;
  String name, grpId, grpName;

  _states() async {
    var user = await FirebaseAuth.instance.currentUser();
    email = user.email;
    //name=user.name;
    //debugPrint(email);
  }

  @override
  Widget build(BuildContext context) {
    _states();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(

          stream: Firestore.instance
              .collection("group_details")
              .where('farmer_id', arrayContains: email)
              .snapshots(),

          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: new CircularProgressIndicator());
            } else {
              return new ListView(

                children: snapshot.data.documents.map((document) {
                  //print(grp_id);
                  return ListTile(
                    leading: new CircleAvatar(
                        child: new Text(
                          document['group_name'][0],
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Colors.yellow),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(document['group_name'],
                            style: Theme.of(context).textTheme.subhead),
                      ],
                    ),
                    onTap: () {
                      grpId = document.documentID;
                      grpName = document['group_name'];
                      returnName(email, grpId, grpName, context);
                    },
                  );
                }).toList(),
              );
            }
          }),
        floatingActionButton: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              tooltip: 'JOIN EXISTING GROUP',
              backgroundColor: Colors.lightGreen,
              elevation: 10.0,
              heroTag: null,
              child: Icon(Icons.group_add, color: Colors.white,),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (builder) => Join()));
              },
            ),
            SizedBox(height: 10.0),
            FloatingActionButton(
              tooltip: 'CREATE NEW GROUP',
              backgroundColor: Colors.lightGreen,
              elevation: 10.0,
              heroTag: null,
              child: Icon(Icons.add, color: Colors.white,),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (builder) => Create()));
              },
            ),
          ],
        )
    );
  }
}

returnName(String email, String grpId, String grpName, BuildContext context) {
  print('pqr');
  print(email);
  final DocumentReference docref = Firestore.instance
      .collection("farmer_details").document(email);
  docref.get().then((datasnapshot) {
    if (datasnapshot.exists) {
      String name = datasnapshot.data['name'];
      print('now passing data');
      print(name);
      print(grpId);
      Navigator.push(
          context, MaterialPageRoute(
          builder: (builder) => ChatPage(name, grpId, grpName)));
    }
  });
}