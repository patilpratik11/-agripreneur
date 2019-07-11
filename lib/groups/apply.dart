import 'package:agripreneur/groups/view_accepted_application.dart';
import 'package:agripreneur/groups/view_requested_application.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Apply extends StatefulWidget {
  Apply(this.grpId);
final String grpId;
  @override
  _ApplyState createState() => _ApplyState();
}


class _ApplyState extends State<Apply> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF77ab59),
          title: Text('APPLY TO BUYERS'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              })),
      body: StreamBuilder(
          stream:
              Firestore.instance.collection("buyer_application").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: new CircularProgressIndicator());
            } else {

              return ListView(
                children: snapshot.data.documents.map((document) {
                  String doc;
                  doc=document.documentID;
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
                              document['Name'].toString(),
                              softWrap: true,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  decorationStyle: TextDecorationStyle.solid,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  letterSpacing: 2.0,),
                            ),
                            Divider(height:10.0),
                            Text("Need:"+
                              document['commodity'].toString(),
                              style: TextStyle(
                                decorationStyle: TextDecorationStyle.solid,
                                fontSize: 16,

                                letterSpacing: 2.0,
                              ),
                            ),
                            Divider(height:10.0),
                            Text("Quantity:"+
                              document['quantity'].toString(),
                              style: TextStyle(
                                decorationStyle: TextDecorationStyle.solid,
                                fontSize: 16,

                                letterSpacing: 2.0,
                              ),
                            ),
                            Divider(height: 10.0,),

                            Row(
                               children: <Widget>[
                                  SizedBox(width: 55.0,),
                                 RaisedButton(
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    splashColor: Colors.yellow,
                                    onPressed: () {
                                     List <String> abc=[widget.grpId.toString()];
                                      //  Map<Arrayy, String> data = <String, String>{
                                      // 'request_id':widget.grpId.toString(),
                                      //   };
                                      var docref=Firestore.instance.collection('buyer_application').document(doc);
                                      print(doc);
                                      docref.updateData({
                                          'request_id':FieldValue.arrayUnion(abc),
                                      });
                                     //Firestore.instance.collection('buyer_application').document(doc).setData({'request_id':FieldValue.arrayUnion([widget.grpId.toString()])});
                                    },
                                    child: Text('Apply'),
                                  ),
                                  SizedBox(width: 25.0,),
                                  RaisedButton(
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    splashColor: Colors.yellow,
                                    onPressed: () =>informations(context,document),

                                    child: Text('More'),
                                  ),
                               ],
                             ),

                          ],
                        ),
                      ));
                }).toList(),
              );
            }
          }),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            icon: Icon(Icons.remove_red_eye),
            tooltip: 'View Requested Applications',
            backgroundColor: Colors.lightBlue,
            elevation: 10.0,
            heroTag: null,
            label: Text('APPLIED'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ViewRequested(widget.grpId)));
            },
          ),
          SizedBox(height: 10.0),
          FloatingActionButton.extended(
            icon: Icon(Icons.remove_red_eye),
            tooltip: 'Accepted Applications',
            backgroundColor: Colors.brown,
            elevation: 10.0,
            heroTag: null,
            label: Text('ACCEPTED'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ViewAccepted(widget.grpId)));
            },
          ),
        ],
      ),
    );
  }
}

Future<bool> informations(BuildContext context, document){
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext contxt){
        return AlertDialog(
          title: Text("information"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Need:'+document['Name']),
                SizedBox(height: 10.0,),
                Text('Commodity:'+document['commodity']),
                SizedBox(height: 10.0,),
                Text('Quantity:'+document['quantity'].toString()),
                SizedBox(height: 10.0,),
                Text('Description:'+document['description']),
              ],
            ),
          ),
        );
      }

    );
  }