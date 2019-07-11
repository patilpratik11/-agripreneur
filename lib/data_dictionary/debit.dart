import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Debit extends StatefulWidget {
  @override
  _DebitState createState() => _DebitState();
}

class _FormData {
  int amount = 0;
  String note = '';
}

class _DebitState extends State<Debit> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  _FormData _data = new _FormData();

  String email;

  _states(int amt, String notes) async {
    var user = await FirebaseAuth.instance.currentUser();
    email = user.email;
    createGroup(amt, notes, email);
  }

  void createGroup(int amt, String notes, String email) {
    try {
      DocumentReference docref =
          Firestore.instance.collection('group_details').document();

      String dId = docref.documentID;
      Map<String, String> data = <String, String>{
        "farmer_id": email,
        "note": dId,
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

      int amt = _data.amount;
      String note1 = _data.note;

      _states(amt, note1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF77ab59),
          title: Text('DEBIT AMOUNT'),
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
                      keyboardType: TextInputType.number,
                      // Use email input type for emails.
                      decoration: new InputDecoration(
                          hintText: '100', labelText: 'Enter amount'),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Amount cannot be empty';
                        }
                      },
                      onSaved: (String val) {
                        this._data.amount = int.parse(val);
                        int x = this._data.amount;
                        print(x);
                      }),
                  new TextFormField(
                      // Use secure text for passwords.
                      decoration: new InputDecoration(
                          hintText: 'fertilizers', labelText: 'Enter a Note'),
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Note cannot be empty';
                        }
                      },
                      onSaved: (String value) {
                        this._data.note = value;
                      }),
                  Center(
                    child: new Container(
                      width: 200.0,
                      child: new RaisedButton(
                        child: new Text(
                          'DEBIT',
                          style: new TextStyle(color: Colors.white),
                        ),
                        onPressed: this.submit,
                        color: Colors.redAccent,
                      ),
                      margin: new EdgeInsets.only(top: 20.0),
                    ),
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
