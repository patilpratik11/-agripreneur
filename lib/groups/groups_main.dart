import 'package:agripreneur/groups/chats.dart';
import 'package:agripreneur/groups/create.dart';
import 'package:agripreneur/groups/join.dart';
import 'package:flutter/material.dart';


class GroupsMain extends StatefulWidget {
  @override
  _GroupsMainState createState() => _GroupsMainState();
}

class _GroupsMainState extends State<GroupsMain> {
  int _selectedIndex1 = 0;

  @override
  Widget build(BuildContext context) {
    return _renderGroupsSubBody();
  }

  Widget _renderGroupsBody() {
    if (_selectedIndex1 == 0) {
      return Chats();
    } else if (_selectedIndex1 == 1) {
      return Join();
    } else if (_selectedIndex1 == 2) {
      return Container(child: RaisedButton(onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (builder) => Create()));
      }));
    } else {
      return AlertDialog(
        title: Text("ERROR! PLEASE SELECT A VALID OPTION",
            style: TextStyle(color: Colors.red)),
      );
    }
  }

  void _onItemTapped1(int index1) {
    setState(() {
      _selectedIndex1 = index1;
    });
  }

  Widget _renderGroupsSubBody() {
    return Scaffold(
        backgroundColor: Color(0xFF77ab59),
        body: _renderGroupsBody(),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.chat, color: Colors.lightGreen),
                title: Text(
                  'Chats',
                  style: TextStyle(color: Colors.black54),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.group_add,
                  color: Colors.lightGreen,
                ),
                title: Text(
                  'Join Group',
                  style: TextStyle(color: Colors.black54),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.add, color: Colors.lightGreen),
                title: Text(
                  'Create',
                  style: TextStyle(color: Colors.black54),
                )),
          ],
          currentIndex: _selectedIndex1,
          onTap: _onItemTapped1,
        ));
  }
}
