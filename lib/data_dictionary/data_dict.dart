import 'package:agripreneur/data_dictionary/credit.dart';
import 'package:agripreneur/data_dictionary/debit.dart';
import 'package:flutter/material.dart';

class DataDictionary extends StatefulWidget {
  @override
  _DataDictionaryState createState() => _DataDictionaryState();
}

class _DataDictionaryState extends State<DataDictionary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.0),
          padding: EdgeInsets.only(top: 100.0),
          child: Column(
            children: <Widget>[
              Text(
                'TOTAL: ',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'DEBIT: ',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                'BALANCE: ',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              ),
              SizedBox(
                height: 40.0,
                width: 10.0,
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20.0),
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                        width: 10.0,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (builder) => Credit()));
                        },
                        heroTag: null,
                        elevation: 10.0,
                        child: Icon(Icons.add),
                        backgroundColor: Colors.lightGreen,
                      ),
                      SizedBox(
                        height: 20.0,
                        width: 10.0,
                      ),
                      RaisedButton(
                        onPressed: () {},
                        child: Text('VIEW'),
                      ),
                      SizedBox(
                        height: 20.0,
                        width: 10.0,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (builder) => Debit()));
                        },
                        heroTag: null,
                        elevation: 10.0,
                        child: Icon(Icons.remove),
                        backgroundColor: Colors.lightGreen,
                      ),
                      SizedBox(
                        height: 20.0,
                        width: 10.0,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
