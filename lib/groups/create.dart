import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Create extends StatefulWidget {
  @override
  _CreateState createState() => _CreateState();
}

class _FormData {
  String groupName;
  String location;
  String cropName;
}

class _CreateState extends State<Create> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _FormData _data = new _FormData();

  String email;

  _states(String gName, String location, String searchKey,
      String cropName) async {
    var user = await FirebaseAuth.instance.currentUser();
    email = user.email;
    createGroup(gName, location, searchKey, email, cropName);
  }

  void createGroup(String gName, String location, String searchKey,
      String email, String cropName) {
    try {
      DocumentReference docref =
      Firestore.instance.collection('group_details').document();

      String dId = docref.documentID;
      Map<String, String> data = <String, String>{
        "admin": email,
        "group_id": dId,
        "group_name": gName,
        "location": location,
        "searchKey": searchKey,
        "crop_name": cropName,
      };
      docref.setData(data).whenComplete(() {
        Navigator.pop(context);
      }).catchError((e) => print(e));
      List<String> abc = [email];
      var docref1 =
      Firestore.instance.collection('group_details').document(dId);
      docref1.updateData({
        'farmer_id': FieldValue.arrayUnion(abc),
      });
      print(dId);
    } catch (e) {
      print(e);
    }
  }

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.

      String gName = _data.groupName;
      String location = _data.location;
      String searchKey = _data.location[0];
      String cropName = _data.cropName;
      _states(gName, location, searchKey, cropName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery
        .of(context)
        .size;

    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF77ab59),
          title: Text('Create new group'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: new Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: new Form(
                  key: this._formKey,
                  child: new ListView(
                    children: <Widget>[
                      new TextFormField(
                          keyboardType: TextInputType
                              .text, // Use email input type for emails.
                          decoration: new InputDecoration(
                              hintText: 'Kisan', labelText: 'Group Name'),
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Group name cannot be empty';
                            }
                          },
                          onSaved: (String value) {
                            this._data.groupName = value;
                          }),
                      new TextFormField(
                          textCapitalization: TextCapitalization.characters,
                          // Use secure text for passwords.
                          decoration: new InputDecoration(
                              hintText: 'PUNE',
                              labelText: 'District Name (PLEASE ENTER CAREFULLY)'),
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Location cannot be empty';
                            }
                          },
                          onSaved: (String value) {
                            this._data.location = value;
                          }),
                      new TextFormField(
                        // Use secure text for passwords.
                          decoration: new InputDecoration(
                              hintText: 'Cotton',
                              labelText: 'Crop Name'),
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Location cannot be empty';
                            }
                          },
                          onSaved: (String value) {
                            this._data.cropName = value;
                          }),
                      new Container(
                        width: screenSize.width,
                        child: new RaisedButton(
                          child: new Text(
                            'CREATE',
                            style: new TextStyle(color: Colors.white),
                          ),
                          onPressed: this.submit,
                          color: Colors.lightGreen,
                        ),
                        margin: new EdgeInsets.only(top: 20.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
