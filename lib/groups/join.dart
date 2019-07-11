import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'searchservice.dart';

class Join extends StatefulWidget {


  @override
  _JoinState createState() => _JoinState();
}

class _JoinState extends State<Join> {
  var queryResultSet = [];
  var tempSearchStore = [];
  var cropName = [];
  double pos = 10.0;

  String email;
  List<String> fid = new List(1);


  _states(String grpId) async {
    var user = await FirebaseAuth.instance.currentUser();
    email = user.email;
    debugPrint(email);
    fid[0] = email;
    var docref = Firestore.instance.collection('group_details')
        .document(grpId);
    docref.updateData({'request_id': FieldValue.arrayUnion(fid)})
        .whenComplete(() {
      Navigator.pop(context);
    })
        .catchError((e) => print(e));
  }

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];

      queryResultSet.forEach((element) {
        if (element['location'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xFF77ab59),
            title: Text('Join a group'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                })),
        body: ListView(children: <Widget>[

          Container(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: TextField(
              keyboardType: TextInputType.text,
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.search),
                    iconSize: 20.0,
                    onPressed: () {},
                  ),
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by district name',
                  border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(4.0))),

            ),
          ),
          Container(
            child: GridView.count(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                primary: false,
                shrinkWrap: true,
                children: tempSearchStore.map((element) {
                  if (element == 0) {
                    return Center(child: CircularProgressIndicator());
                  }
                  else {
                    return buildResultCard(element, context);
                  }
                }).toList()),
          ),
        ]
        )
    );
  }


  Widget buildResultCard(data, BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        child: Container(
            child: Column(children: <Widget>[
              SizedBox(height: 15.0),
              Center(
                  child: Text(
                    data['group_name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  )),
              SizedBox(
                height: 25.0,
              ),
              Center(
                child: Text(
                  "Crop:" + data['crop_name'], textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),),
              ),
              SizedBox(
                height: 25.0,
              ),
              RaisedButton(
                onPressed: () {
                  String x = data['group_id'];
                  print(x);
                  _states(x);
                },
                child: Text("JOIN"),
                color: Colors.lightGreen,
              )
            ]
            )
        )
    );
  }
}