import 'package:flutter/material.dart';
import 'package:goalapp/module/goal.dart';

class SecondPage extends StatefulWidget {
  String name;

  SecondPage({this.name}); // 책 200Page 참고
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final _list = <Goal>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리스트 보기'),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
              child: ListView(children: _list.map((goal) => _buildItemWidget(goal)).toList())),
          RaisedButton(
            onPressed: () {
              print(widget.name);
            },
            child: Text('widget.name 확인하기'),
          )
        ],
      ),
    );
  }

  Widget _buildItemWidget(Goal goal) {
    return ListTile(
      title: Text(goal.name),
    );
  }
}
