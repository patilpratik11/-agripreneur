import 'package:agripreneur/groups/view_buy.dart';
import 'package:agripreneur/groups/view_purchased.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Buy extends StatefulWidget {
  Buy(this.grpId);

  final String grpId;
  @override
  _BuyState createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF77ab59),
          title: Text('Buy From Manufacturers'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              })),
      body:StreamBuilder(
          stream:
          Firestore.instance.collection("products").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return new CircularProgressIndicator();
            } else {

              return ListView(
                children: snapshot.data.documents.map((document) {
                  // String doc;
                  // doc=document.documentID;
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
                            Text("Price:"+
                                document['Price'].toString(),
                              style: TextStyle(
                                decorationStyle: TextDecorationStyle.solid,
                                fontSize: 16,

                                letterSpacing: 2.0,
                              ),
                            ),
                            Divider(height:10.0),
                            Text("In Stock:"+
                                document['quantity'].toString(),
                              style: TextStyle(
                                decorationStyle: TextDecorationStyle.solid,
                                fontSize: 16,

                                letterSpacing: 2.0,
                              ),
                            ),
                            Divider(height: 10.0,),
                            Text("Type:"+
                                document['type'].toString(),
                              style: TextStyle(
                                decorationStyle: TextDecorationStyle.solid,
                                fontSize: 16,
                                letterSpacing: 2.0,
                              ),
                            ),

                            Row(
                              children: <Widget>[
                                SizedBox(width: 55.0,),
                                RaisedButton(
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  splashColor: Colors.yellow,
                                  onPressed: () {
                                    print(widget.grpId);
                                    String docId = document.documentID;
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (builder) =>
                                            ViewBuy(widget.grpId, docId)));
                                    //   List <String> abc=[widget.grpId.toString()];
                                    //  Map<Arrayy, String> data = <String, String>{
                                    // 'request_id':widget.grpId.toString(),
                                    //   };
                                    // var docref=Firestore.instance.collection('buyer_application').document(doc);
                                    // print(doc);
                                    // docref.updateData({
                                    //    'request_id':FieldValue.arrayUnion(abc),
                                    // });
                                    //Firestore.instance.collection('buyer_application').document(doc).setData({'request_id':FieldValue.arrayUnion([widget.grpId.toString()])});
                                  },
                                  child: Text('Buy'),
                                ),
                                SizedBox(width: 25.0,),
                                RaisedButton(
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  splashColor: Colors.yellow,
                                  onPressed: () =>
                                      informations(context, document),

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
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(
                builder: (builder) => ViewPurchased(widget.grpId))
            );
          },
          elevation: 10.0,
          heroTag: null,
          label: Text('VIEW PURCHASED PRODUCTS'),
          icon: Icon(Icons.remove_red_eye)
      ),
    );
  }
}


Future<bool> informations(BuildContext context, document){
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext contxt) {
        return AlertDialog(
          title: Text("Information"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Product: '+document['Name'].toString()),
                SizedBox(height: 10.0,),
                Text('Price: '+document['Price'].toString()+' Rs per item'),
                SizedBox(height: 10.0,),
                Text('In Stock: '+document['quantity'].toString()),
                SizedBox(height: 10.0,),
                Text('Description:  '+document['description'].toString()),
              ],
            ),
          ),
          actions: <Widget>[
            // FlatButton(
            //   onPressed: ()=>Navigator.pop(context),

            // )
          ],
        );
      }

  );
}