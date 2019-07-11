import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewBuy extends StatefulWidget {
  ViewBuy(this.grpId, this.docId);
  final String grpId;
  final String docId;
  @override
  _ViewBuyState createState() => _ViewBuyState();
}

class _ViewBuyState extends State<ViewBuy> {
  final FocusNode focusQuantity = FocusNode();
  String tPrice = '';
  TextEditingController controllerQuantity = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    int quantity = 0;
    int price = 0,
        text = 0,
        total_price = 0;
    String manufacture_id;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF77ab59),
        title: Text("Buy List"),
      ),
      //

      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 5.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 40.0, top: 39.0, right: 40.0, bottom: 20.0),
                        child: TextFormField(
                          focusNode: focusQuantity,
                          controller: controllerQuantity,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                                color: Colors.black,
                                icon: Icon(Icons.arrow_back),
                                iconSize: 20.0,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              contentPadding: EdgeInsets.only(left: 25.0),
                              hintText: 'Enter Quantity',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.0))),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          print(controllerQuantity.text);
                          text = int.parse(controllerQuantity.text);
                          print(text);
                          var docRef = Firestore.instance
                              .collection('products')
                              .document(widget.docId);
                          docRef.get().then((datasnapshot) {
                            if (datasnapshot.exists) {
                              quantity = datasnapshot.data['quantity'];
                              print(quantity);
                              price = datasnapshot.data['Price'];
                              print(price);
                              manufacture_id =
                              datasnapshot.data['manufacturer_id'];
                              if (quantity >= text) {
                                total_price = text * price;
                                tPrice = total_price.toString();
                                print(tPrice);

                                Map<String, String> data1 = <String, String>{
                                  'group_id': widget.grpId.toString(),
                                  'manufacturer_Id': manufacture_id,
                                  'product_id': widget.docId,
                                  'purchase_quantity': text.toString(),
                                  'total_price': total_price.toString(),
                                };
                                Firestore.instance
                                    .collection('purchase_products')
                                    .document()
                                    .setData(data1)
                                    .whenComplete(() {
                                  print('SUCESSFULL');
                                  quantity -= text;
                                  Map<String, int> data2 = <String, int>{
                                    'quantity': quantity,
                                  };
                                  Firestore.instance
                                      .collection('products')
                                      .document(widget.docId)
                                      .updateData(data2)
                                      .whenComplete(() {
                                    print('SUCESS TO UPDATE QUANTITY');

                                    informations(context, tPrice);
                                  }).catchError((e) => print(e));
                                }).catchError((e) => print(e));
                              }
                            }
                          });
                        },
                        child: Text(" Buy "),
                        textColor: Colors.white,
                        color: Colors.lightGreen,
                        elevation: 5.0,
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> informations(BuildContext context, tPrice) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Information"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ORDER PLACED SUCESSFULLY'),
                SizedBox(
                  height: 10.0,
                ),
                Text('Total Price: Rs ' + tPrice),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // FlatButton(
            //   onPressed: ()=>Navigator.pop(context),

            // )
          ],
        );
      });
}
