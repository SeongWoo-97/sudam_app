import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytraveldiary/page/Album.dart';
import 'package:mytraveldiary/page/Home.dart';
import 'package:mytraveldiary/page/Profile.dart';
import 'package:mytraveldiary/page/Write.dart';
import 'package:mytraveldiary/service/authservice.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userID, this.logoutCallback})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userID;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  String userName;
  String email;
  final _globalKey = GlobalKey<ScaffoldState>();
  final List<Text> _text = [Text('홈'), Text('앨범'), Text('글 쓰기'), Text('내 정보')];
  final List<Icon> _icon = [
    Icon(Icons.home),
    Icon(Icons.photo_album),
    Icon(Icons.border_color),
    Icon(Icons.person)
  ];

  @override
  Widget build(BuildContext context) {
    showDocument(widget.userID); // userName DB에 저장된 닉네임 저장
    final List<Widget> _page = [
      Home(),
      Album(),
      Write(),
      Profile(
        auth: widget.auth,
        userID: widget.userID,
        logoutCallback: widget.logoutCallback,
        userName: userName,
        email: email,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: bottomBar,
      body: _page[_index],
    );
  }

  Widget get bottomBar => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTapped,
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(
            icon: _icon[0],
            title: _text[0],
          ),
          BottomNavigationBarItem(
            icon: _icon[1],
            title: _text[1],
          ),
          BottomNavigationBarItem(
            icon: _icon[2],
            title: _text[2],
          ),
          BottomNavigationBarItem(
            icon: _icon[3],
            title: _text[3],
          ),
        ],
      );
  void _onTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  void showDocument(String user) {
    Firestore.instance
        .collection('User')
        .document(user)
        .get()
        .then((DocumentSnapshot ds) {
      userName = ds.data['username'];
      email = ds.data['email'];
    });
  }
}
