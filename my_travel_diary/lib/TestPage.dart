import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  String testID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(height: 40),
                  Container(
                      width: 300,
                      height: 130,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _controller,
                              //validator: validateEmail, //유효성 검사
                              onSaved: (value) => testID = value.trim(),
                              maxLines: 1,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                hintText: '닉네임 입력',
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black54,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                              ),
                            ),
                            RaisedButton(
                                color: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.0))),
                                child: Text(
                                  '중복확인',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  FutureBuilder(
                                    future: doesNameAlreadyExist(testID),
                                    builder: (context, AsyncSnapshot<bool> result) {
                                      print('g');
                                      if (!result.hasData) {
                                        print('g');
                                        return Container();
                                      } // future still needs to be finished (loading)
                                      if (result.data) { // result.data is the returned bool from doesNameAlreadyExists
                                        print('gd');
                                        return Text(
                                            'A company called "Nova" already exists.');
                                      }
                                      else {
                                        print('g');
                                        return Text(
                                            'No company called "Nova" exists yet.');
                                      }
                                    },
                                  );
                                }),
                          ],
                        ),
                      )),
                ],
              )
            ],
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(255, 235, 208, 1),
    );
  }

  Future<bool> doesNameAlreadyExist(String name) async {
    print('g');
    final QuerySnapshot result = await Firestore.instance
        .collection('User')
        .where('test@test.com', isEqualTo: 'test@test.com')
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents.length == 1;
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Enter Valid Email Id!!!';
    else
      return null;
  }
}
