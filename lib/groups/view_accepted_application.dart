import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewAccepted extends StatefulWidget {
  ViewAccepted(this.grpId);

  final String grpId;

  @override
  _ViewAcceptedState createState() => _ViewAcceptedState();
}

class _ViewAcceptedState extends State<ViewAccepted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Applied Applications"),
        backgroundColor: Color(0xFF77ab59),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('buyer_application')
            .where('accept_id', arrayContains: widget.grpId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return new CircularProgressIndicator();
          } else {
            return ListView(
              children: snapshot.data.documents.map((document) {
                return Card(
                    margin: EdgeInsets.all(12.0),
                    elevation: 4.0,
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            document['Name'],
                            softWrap: true,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              decorationStyle: TextDecorationStyle.solid,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Divider(height: 10.0),
                          Text(
                            "Commodity:" + document['commodity'],
                            style: TextStyle(
                              decorationStyle: TextDecorationStyle.solid,
                              fontSize: 16,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Divider(height: 10.0),
                          Text(
                            "Quantity:" + document['quantity'].toString(),
                            style: TextStyle(
                              decorationStyle: TextDecorationStyle.solid,
                              fontSize: 16,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Divider(height: 10.0),
                          SizedBox(
                            width: 25.0,
                          ),
                          RaisedButton(
                            color: Colors.green,
                            textColor: Colors.white,
                            splashColor: Colors.yellow,
                            onPressed: () => informations(context, document),
                            child: Text('More'),
                          ),
                        ],
                      ),
                    ));
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

Future<bool> informations(BuildContext context, document) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext contxt) {
        return AlertDialog(
          title: Text("information"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Need:' + document['Name']),
                SizedBox(
                  height: 10.0,
                ),
                Text('Commodity:' + document['commodity']),
                SizedBox(
                  height: 10.0,
                ),
                Text('Quantity:' + document['quantity'].toString()),
                SizedBox(
                  height: 10.0,
                ),
                Text('Description:' + document['description']),
              ],
            ),
          ),
        );
      });
}
