import 'package:flutter/material.dart';
import 'package:goalapp/main.dart';
import 'package:goalapp/module/goal.dart';

import 'SecondPage.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

// 목표 객체를 만들 클래스를 생성
// 생성된 객체를 내부저장소에 저장
class _FirstPageState extends State<FirstPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _names = TextEditingController();
  Goal goal;

  @override
  void dispose() {
    _names.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('목표 추가하기'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _names,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            filled: true,
                            hintText: 'Goal Name'),
                      ),
                    ],
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SecondPage(
                        name: _names.text,
                      )
                  ));
                },
                child: Text('Create'),
              )
            ],
          )
        ],
      ),
    );
  }
}
