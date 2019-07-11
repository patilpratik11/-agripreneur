import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewNotification extends StatefulWidget {
  ViewNotification(this.grpId);

  final String grpId;

  @override
  _ViewNotificationState createState() => _ViewNotificationState();
}

class _ViewNotificationState extends State<ViewNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color(0xFF77ab59),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('group_details')
            .document(widget.grpId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot1) {
          if (!snapshot1.hasData) {
            return Center(child: new RefreshProgressIndicator(),);
          } else {
//                          List<String> x;
            print('some');
            List x = [];
            if (snapshot1.data['request_id'] == null) {
              Text('no data');
            } else {
              x = snapshot1.data['request_id'];
              print(x.length);
              String y = x[0];
              print('ho pls run');
              print(y);
              int f = x.length.toInt();
              print(f);
              if (f == 0) {
                return Text("No Request");
              }
              else {
                return ListView.builder(
                  itemCount: x.length,
                  itemBuilder: (BuildContext context, int index) {
                    print("abcbabbabc");
                    //           DocumentReference docref= Firestore.instance.collection("farmer_details").document(x[index]);
//                              data[]
                    return StreamBuilder(
                        stream: Firestore.instance
                            .collection('farmer_details')
                            .document(x[index])
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return new CircularProgressIndicator();
                          } else {
                            String name = snapshot.data['name'];
                            return Container(
                              child: Card(
                                  margin: EdgeInsets.all(12.0),
                                  elevation: 4.0,
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: <Widget>[
                                        Text(
                                          name,
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.clip,
                                          style: TextStyle(
                                            decorationStyle:
                                            TextDecorationStyle.solid,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            letterSpacing: 2.0,
                                          ),
                                        ),
                                        Divider(height: 10.0),
                                        Row(
                                          children: <Widget>[
                                            SizedBox(width: 45.0,),
                                            RaisedButton(
                                              onPressed: () {
                                                var docRef = Firestore.instance
                                                    .collection('group_details')
                                                    .document(widget.grpId);
                                                docRef.get().then((
                                                    datasnapshot) {
                                                  if (datasnapshot.exists) {
                                                    List<String> abc = [x[index]
                                                    ];
//                                            var docref1 = Firestore.instance
//                                                .collection('group_details')
//                                                .document(widget.grpId);
                                                    docRef.updateData({
                                                      'farmer_id':
                                                      FieldValue.arrayUnion(
                                                          abc),
                                                    });
                                                    docRef.updateData({
                                                      'request_id':
                                                      FieldValue.arrayRemove(
                                                          abc),
                                                    });
                                                  }
                                                }).catchError((e) => print(e));
                                              },
                                              child: Text("Accept"),
                                              textColor: Colors.white,
                                              color: Colors.lightGreen,
                                              elevation: 5.0,
                                            ),
                                            SizedBox(width: 55.0,),
                                            RaisedButton(
                                              onPressed: () {
                                                var docRef = Firestore.instance
                                                    .collection('group_details')
                                                    .document(widget.grpId);
                                                docRef.get().then((
                                                    datasnapshot) {
                                                  if (datasnapshot.exists) {
                                                    List<String> abc = [x[index]
                                                    ];
                                                    var docref = Firestore
                                                        .instance
                                                        .collection(
                                                        'group_details')
                                                        .document(widget.grpId);
                                                    docref.updateData({
                                                      'request_id':
                                                      FieldValue.arrayRemove(
                                                          abc),
                                                    });
                                                  }
                                                }).catchError((e) => print(e));
                                              },
                                              child: Text("Reject"),
                                              textColor: Colors.white,
                                              color: Colors.redAccent,
                                              elevation: 5.0,
                                            ),

                                          ],
                                        ),

                                      ],
                                    ),
                                  )),
                            );
                          }
                        });
                  },
                );
              }
            }
          }
        },
      ),
    );
  }
}
