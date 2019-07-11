import 'package:agripreneur/Constants.dart';
import 'package:agripreneur/data_dictionary/data_dict.dart';
import 'package:agripreneur/groups/chats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  String email;
  _states() async {
    var user = await FirebaseAuth.instance.currentUser();
    email = user.email;
    debugPrint(email);
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed:
                () => Navigator.of(context).pop(false)
            ,
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed:
                () {
              SystemNavigator.pop();
            },

            //() => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    _states();
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
        home: Scaffold(

          appBar: AppBar(
            backgroundColor: Color(0xFF77ab59),
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
              _onWillPop();
            }),
            title: Text('Welcome to Agripreneur'),

          ),
          body: _renderBody(),
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: Color(0xFF77ab59),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.group, color: Colors.green),
                  title: Text(
                    'Groups',
                    style: TextStyle(color: Colors.black54),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet, color: Colors.green),
                  title: Text(
                    'Money Manager',
                    style: TextStyle(color: Colors.black54),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance, color: Colors.green),
                  title: Text(
                    'Schemes',
                    style: TextStyle(color: Colors.black54),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.school,
                    color: Colors.green,
                  ),
                  title: Text(
                    'Guidance',
                    style: TextStyle(color: Colors.black54),
                  ))
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Settings) {
      print('Settings');
    } else if (choice == Constants.Subscribe) {
      print('Subscribe');
    } else if (choice == Constants.SignOut) {
      print('SignOut');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _renderBody() {
    if (_selectedIndex == 0) {
      return Chats();
    } else if (_selectedIndex == 1) {
      return DataDictionary();
    }
    else if (_selectedIndex == 2) {
      return _renderSchemesBody();
    } else if (_selectedIndex == 3) {
      return _renderGuidanceBody();
    } else {
      return AlertDialog(
        title: Text("ERROR! PLEASE SELECT A VALID OPTION",
            style: TextStyle(color: Colors.red)),
      );
    }
  }

  Widget _renderSchemesBody() {
    return Center(
      child: Text(
        'Coming Soon!',
        style: TextStyle(
            letterSpacing: 2.0,
            fontSize: 40,
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _renderGuidanceBody() {
    return Center(
      child: Text(
        'Coming Soon!',
        style: TextStyle(
            letterSpacing: 2.0,
            fontSize: 41,
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
//
//Widget getListView() {
//  var listItems = getListElements();
//
//  var listView = ListView.builder(itemBuilder: (context, index) {
//    return ListTile(
//      leading: new CircleAvatar(
//          child: new Text(
//            document['group_name'][0],
//            style: TextStyle(color: Colors.black),
//          ),
//          backgroundColor: Colors.yellow),
//      title: new Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          new Text('Group Name $index',
//              style: Theme.of(context).textTheme.subhead),
//          new Container(
//            margin: const EdgeInsets.only(top: 5.0),
//            child: new Text(
//              'Description of group no $index',
//              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
//            ),
//          ),
//        ],
//      ),
//      onTap: () {
//        debugPrint('${listItems[index]} was tapped');
//      },
//    );
//  });
//
//  return listView;
//}
//
//List<String> getListElements() {
//  var items = List<String>.generate(50, (counter) => "Item $counter");
//  return items;
//}

//class Choice {
//  const Choice({this.title, this.icon});
//
//  final String title;
//  final IconData icon;
//}
//
//const List<Choice> choices = const <Choice>[
//  const Choice(title: 'Car', icon: Icons.directions_car),
//  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
//  const Choice(title: 'Boat', icon: Icons.directions_boat),
//  const Choice(title: 'Bus', icon: Icons.directions_bus),
//  const Choice(title: 'Train', icon: Icons.directions_railway),
//  const Choice(title: 'Walk', icon: Icons.directions_walk),
//];
//
//class ChoiceCard extends StatelessWidget {
//  const ChoiceCard({Key key, this.choice}) : super(key: key);
//
//  final Choice choice;
//
//  @override
//  Widget build(BuildContext context) {
//    final TextStyle textStyle = Theme.of(context).textTheme.display1;
//    return Card(
//      color: Colors.white,
//      child: Center(
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            Icon(choice.icon, size: 128.0, color: textStyle.color),
//            Text(choice.title, style: textStyle),
//          ],
//        ),
//      ),
//    );
//  }
//}
