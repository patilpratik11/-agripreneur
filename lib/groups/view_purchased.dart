import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPurchased extends StatefulWidget {
  ViewPurchased(this.grpId);

  final String grpId;

  @override
  _ViewPurchasedState createState() => _ViewPurchasedState();
}

class _ViewPurchasedState extends State<ViewPurchased> {
  String product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF77ab59),
        title: Text('Purchased Products'),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('purchase_products')
              .where('group_id', isEqualTo: widget.grpId.toString())
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return new CircularProgressIndicator();
            } else {
              return ListView(
                children: snapshot.data.documents.map((document) {
                  product = document['product_id'];
                  print('kahipn');
                  print(product);
                  return StreamBuilder(
                      stream: Firestore.instance
                          .collection('products')
                          .document(product)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot1) {
                        if (!snapshot1.hasData) {
                          return new CircularProgressIndicator();
                        } else {
                          String xyz, ppq;
                          print('inside');
                          xyz = snapshot1.data['Name'];
                          print(xyz);
                          ppq = snapshot1.data['Price'].toString();
                          print(ppq);
                          //  snapshot1.data.documents.map((document1){
                          //    print(document1.documentID);
                          //    if(document1.documentID==product){
                          //       xyz=document1['Name'].toString();
                          //    }
                          //  }
                          //  );

                          return Card(
                              margin: EdgeInsets.all(12.0),
                              elevation: 4.0,
                              child: Container(
                                margin: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      xyz.toString(),
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
                                    Text(
                                      "Price Per Item:" + ppq.toString(),
                                      style: TextStyle(
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 16,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                    Divider(height: 10.0),
                                    Text(
                                      "Quantity:" +
                                          document['purchase_quantity']
                                              .toString(),
                                      style: TextStyle(
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 16,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                    Divider(height: 10.0),
                                    Text(
                                      "Total Price:" +
                                          document['total_price'].toString(),
                                      style: TextStyle(
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 16,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        }
                      });
                }).toList(),
              );
            }
          }),
    );
  }
}