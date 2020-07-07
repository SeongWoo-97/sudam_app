import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytraveldiary/images/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'LoginPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nickName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  String successMessage = '';
  String emailId;
  String _password;
  String userName;
  String _confirmpassword;

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
                  Image.asset(
                    'assets/images/logo.png',
                    width: 220,
                    height: 220,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 300,
                    height: 380,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              newEmail,
                              newPW,
                              newPW2,
                              newNickName,
                              submit(),
                            ],
                          ),
                        ),
                        (errorMessage != ''
                            ? Text(
                                errorMessage,
                                style: TextStyle(color: Colors.red),
                              )
                            : Container()),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(255, 235, 208, 1),
    );
  }

  Widget newID() {
    return Container(
      width: 250,
      height: 50,
      child: TextFormField(
        validator: validateEmail,
        onSaved: (value) {
          emailId = value;
        },
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        obscureText: true, // PW : **** 표시
        autofocus: false,
        decoration: InputDecoration(
            hintText: '아이디 입력',
            hintStyle:
                TextStyle(fontSize: 15, height: 1, fontWeight: FontWeight.bold),
            prefixIcon: UserIcon(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      ),
    );
  }

  Widget get newPW => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: TextFormField(
          validator: validatePassword,
          onSaved: (value) {
            _password = value;
          },
          controller: _passwordController,
          maxLines: 1,
          obscureText: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            labelText: '비밀번호 6자리이상 입력해주세요',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.black54,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          ),
        ),
      );
  Widget get newPW2 => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: TextFormField(
          validator: validateConfirmPassword,
          onSaved: (value) {
            _confirmpassword = value;
          },
          controller: _confirmPasswordController,
          maxLines: 1,
          obscureText: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            labelText: '비밀번호 6자리이상 입력해주세요',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.black54,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          ),
        ),
      );
  Widget get newEmail => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: TextFormField(
          validator: validateEmail,
          onSaved: (String value) {
            emailId = value.trim();
          },
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          maxLines: 1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            labelText: '수신가능한 이메일 입력 해주세요',
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black54,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          ),
        ),
      );
  Widget get newNickName => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: TextFormField(
          controller: _nickName,
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

  Widget submit() => RaisedButton(
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Text(
        '아이디 만들기',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: idGenerate);

  Future<void> idGenerate() async {
    if (_formKey.currentState.validate()) { //textformfield 의 validate 검사가 모두 참이면 참
      _formKey.currentState.save(); //textformfield 에 저장된 값을 String 타입으로 변환
      signUp(emailId, _password).then((user) {
        if (userName != null) {
          Firestore.instance.collection('User').document(user.uid).setData({
            "email": emailId,
            "username": userName,
            "uid": user.uid,
          });
          Navigator.pop( //push 로하게되면 왜 회원가입후 로그인이 안되는지 모르겠음
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage())); //toast bar 로그인 완료 표시하기
        } else {
          print('Error while Login.'); //로그인중 오류메세지 창
        }
      });
    }
  }

  Future<FirebaseUser> signUp(email, password) async {
    try {
      FirebaseUser user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      return user;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        setState(() {
          errorMessage = '등록된 이메일 입니다';
        });
        break;
      default:
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return '이메일을 입력하세요';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty || value.length < 6 || value.length > 14) {
      return '비밀번호는 최소 6자리 에서 최대 14자리 입니다';
    }
    return null;
  }

  String validateConfirmPassword(String value) {
    if (value.trim() != _passwordController.text.trim()) {
      return '비밀번호가 같지않습니다';
    }
    return null;
  }
  String validateUserName(String value) {
    if( value.trim().isEmpty){
      return '닉네임을 입력하세요';
    }
    else if(value.length <= 2 || value.length >= 8 ) {
      return '닉네임은 최소 2자리 에서 최대 8자리 입니다';
    }
    return null;
  }
}
