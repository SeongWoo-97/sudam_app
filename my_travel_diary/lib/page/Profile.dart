import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytraveldiary/service/authservice.dart';

class Profile extends StatefulWidget {
  Profile(
      {Key key,
      this.auth,
      this.userID,
      this.logoutCallback,
      this.userName,
      this.email})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userID;
  final String userName;
  final String email;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit, size: 30),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileModify(
                            userID: widget.userID,
                            userName: widget.userName,
                          )));
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.grey,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.email),
                        SizedBox(width: 5),
                        Text(widget.email)
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(Icons.person),
                        SizedBox(width: 5),
                        Text(widget.userName)
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          Divider(
            height: 70,
            thickness: 10,
            indent: 30,
            endIndent: 30,
          ),
          RaisedButton(
            child: Text('로그아웃'),
            onPressed: () {
              signOut();
            },
          ),
        ],
      ),
    );
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
}

class ProfileModify extends StatefulWidget {
  ProfileModify({
    Key key,
    this.userID,
    this.userName,
  }) : super(key: key);
  final String userID;
  final String userName;
  @override
  _ProfileModifyState createState() => _ProfileModifyState();
}

class _ProfileModifyState extends State<ProfileModify> {
  File _image;
  String userName;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Modify Page'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
            child: GestureDetector(
                child: _image != null
                    ? CircleAvatar(
                        backgroundImage: new FileImage(_image),
                        radius: 90.0,
                      )
                    : CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.grey,
                      ),
                onTap: getImage),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 20, right: 20),
            child: Column(
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: nameText)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: RaisedButton(
              child: Text('확인'),
              onPressed: () {
                print(nameController.text);
              },
            ),
          )
        ],
      ),
    );
  }
  Widget get nameText => Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
    child: TextFormField(
      controller: nameController,
      validator: validateUserName,
      onSaved: (value) {
        userName = value;
      },
      maxLines: 1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8),
        labelText: '닉네임 입력',
        labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.black54,
        ),
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
      ),
    ),
  );
  Future<void> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> saveSumit() async {
    if (_formKey.currentState.validate()) { //textformfield 의 validate 검사가 모두 참이면 참
      _formKey.currentState.save(); //textformfield 에 저장된 값을 String 타입으로 변환
        if (userName != null) {
          Firestore.instance.collection('User').document(widget.userID).updateData({
            "username": userName,
          });
          Navigator.pop( //push 로하게되면 왜 회원가입후 로그인이 안되는지 모르겠음
              context,
              MaterialPageRoute(
                  builder: (context) => Profile(userName: userName,))); //toast bar 로그인 완료 표시하기
        } else {
          print('Error while Login.'); //로그인중 오류메세지 창
        }
    }
  }

  String validateUserName(String value) {
    if (value.trim().isEmpty) {
      return '이름을 입력하세요';
    } else if (value.length <= 2 || value.length >= 8) {
      return '이름은 최소 2자리 에서 최대 8자리 입니다';
    }
    return null;
  }
}
