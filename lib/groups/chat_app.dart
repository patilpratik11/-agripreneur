import 'package:agripreneur/groups/apply.dart';
import 'package:agripreneur/groups/buy.dart';
import 'package:agripreneur/groups/qr.dart';
import 'package:agripreneur/groups/view_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {
  ChatPage(this.userName, this.grpId, this.grpName);

  final String userName, grpId, grpName;

  @override
  _ChatPageState createState() => new _ChatPageState();
}

enum GroupPopUp { apply, buy, qrCode }
var grpId;
class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  int _selectedIndex1 = 0;
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.grpName.toString()),
        backgroundColor: Color(0xFF77ab59),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 8.0, right: 20.0),
            child: IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (builder) => ViewNotification(grpId)));
              },
            ),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: <Widget>[
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection("group_chat")
                    .where('group_id', isEqualTo: widget.grpId.toString())
                    .orderBy("created_at", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    debugPrint('abcdef');
                    debugPrint(widget.userName.toString());
                    debugPrint(widget.grpId.toString());
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    debugPrint('abcde');
                    debugPrint(widget.userName.toString());
                    debugPrint(widget.grpId.toString());
                    
                    return new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        DocumentSnapshot document =
                            snapshot.data.documents[index];
                             grpId=document['group_id'];
                        bool isOwnMessage = false;
                        if (document['from'] == widget.userName) {
                          debugPrint('abcd');
                          debugPrint(widget.userName.toString());
                          isOwnMessage = true;
                        }
                        return isOwnMessage
                            ? _ownMessage(document['message'], document['from'])
                            : _message(document['message'], document['from']);
                      },
                      itemCount: snapshot.data.documents.length,
                    );
                  }
                },
              ),
            ),
            new Divider(height: 1.0),
            Container(
              margin: EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10.0),
              child: Row(
                children: <Widget>[
                  new Flexible(
                    child: new TextField(
                      controller: _controller,
                      onChanged: (String text) {
                        //new
                        setState(() {
                          //new
                          _isComposing = text.length > 0; //new
                        }); //new
                      },
                      onSubmitted: _handleSubmit,
                      decoration: new InputDecoration.collapsed(
                          hintText: "Send a message"),
                    ),
                  ),
                  new Container(
                    margin: new EdgeInsets.symmetric(horizontal: 4.0),
                    child: new IconButton(
                      icon: new Icon(Icons.send, color: Color(0xFF77ab59),),
                      onPressed: _isComposing
                          ? () => _handleSubmit(_controller.text) //modified
                          : null,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.chat, color: Colors.lightGreen),
              title: Text(
                'BUY',
                style: TextStyle(color: Colors.black54),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.group_add,
                color: Colors.lightGreen,
              ),
              title: Text(
                'APPLY',
                style: TextStyle(color: Colors.black54),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.add, color: Colors.lightGreen),
              title: Text(
                'GENERATE QR',
                style: TextStyle(color: Colors.black54),
              )),
        ],
        currentIndex: _selectedIndex1,
        onTap: _onItemTapped1,
      ),
    );
  }

  void _onItemTapped1(int index1) {
    _selectedIndex1 = index1;

    if (_selectedIndex1 == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (builder) => Buy(grpId)));
    } else if (_selectedIndex1 == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (builder) => Apply(grpId)));
    } else if (_selectedIndex1 == 2) {
      Navigator.push(
          context, MaterialPageRoute(builder: (builder) => GenerateQr()));
    } else {
      AlertDialog(
        title: Text("ERROR! PLEASE SELECT A VALID OPTION",
            style: TextStyle(color: Colors.red)),
      );
    }
  }

  Widget _ownMessage(String message, String userName) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text('You',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(message),
              ),
            ],
          ),
          new Container(
            margin: const EdgeInsets.only(left: 16.0, top: 10.0, bottom: 10.0),
            child: new CircleAvatar(
                child: new Text(userName[0]), backgroundColor: Colors.yellow),
          ),
        ],
      ),
    );
  }

  Widget _message(String message, String userName) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0, top: 10.0, bottom: 10.0),
            child: new CircleAvatar(
                child: new Text(userName[0]), backgroundColor: Colors.yellow),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(userName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green)),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(message),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _handleSubmit(String message) {
    _controller.text = "";
    var db = Firestore.instance;
    db.collection("group_chat").add({
      "from": widget.userName,
      "message": message,
      "group_id": widget.grpId,
      "created_at": DateTime.now()
    }).then((val) {
      print("sucess");
    }).catchError((err) {
      print(err);
    });
  }
}
