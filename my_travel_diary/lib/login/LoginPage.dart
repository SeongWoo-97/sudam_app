import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytraveldiary/TestPage.dart';
import 'package:mytraveldiary/service/authservice.dart';
import 'FindPW.dart';
import 'SignUp.dart';
import 'UserName.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  String successMessage = '';
  String _emailId;
  String _password;
  bool _isLoginForm;
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
                  logo,
                  Container(
                    width: 300,
                    height: 350,
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
                              idField,
                              pwField,
                            ],
                          ),
                        ),
                        loginButton,
                        signUpButton,
                        passWordForget,
                        Row(
                          children: <Widget>[
//                            testbox,
//                            testingbox,
                          ],
                        )
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

//  Widget get testbox => Row(
//        children: <Widget>[
//          RaisedButton(
//              child: Text('닉네임 창'),
//              onPressed: () {
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => UserName()));
//              })
//        ],
//      );
//  Widget get testingbox => Row(
//        children: <Widget>[
//          RaisedButton(
//              child: Text('테스트 공간'),
//              onPressed: () {
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => TestPage()));
//              })
//        ],
//      );
  Widget get logo => Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Image.asset(
          'assets/images/logo.png',
          width: 261,
          height: 235,
        ),
      );
  Widget get idField => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: TextFormField(
          controller: _emailController,
          validator: validateEmail, //유효성 검사
          onSaved: (value) => _emailId = value.trim(),
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            hintText: '이메일을 입력하세요',
            hintStyle: TextStyle(fontWeight: FontWeight.bold),
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black54,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
          ),
        ),
      );

  Widget get pwField => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
        child: TextFormField(
          controller: _passwordController,
          validator: validatePassword,
          onSaved: (value) => _password = value.trim(),
          maxLines: 1,
          obscureText: true, // PW : **** 표시
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8),
              hintText: '비밀번호를 입력하세요',
              hintStyle: TextStyle(fontWeight: FontWeight.bold),
              prefixIcon: Icon(Icons.lock, color: Colors.black54),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0))),
        ),
      );

  Widget get loginButton => ButtonTheme(
        minWidth: 130,
        height: 30,
        child: RaisedButton(
          child: Text(
            '로그인 하기',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: submit,
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
        ),
      );

  Widget get signUpButton => ButtonTheme(
        minWidth: 130,
        height: 30,
        child: RaisedButton(
          child: Text(
            '회원가입 하기',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          },
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
        ),
      );

  Widget get passWordForget => FlatButton(
        child: Text(
          '비밀번호를 잃어버리셨나요?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FindPW()));
        },
      );



  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_USER_NOT_FOUND':
        setState(() {
          errorMessage = 'User Not Found!!!';
        });
        break;
      case 'ERROR_WRONG_PASSWORD':
        setState(() {
          errorMessage = 'Wrong Password!!!';
        });
        break;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) // if(value.isEmpty || !regex.hasMatch(value))
      return '이메일을 입력하세요';
    else if (!regex.hasMatch(value))
      return '이메일 형식이 올바르지않습니다.';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty) {
      return '비밀번호 확인해주시길 바랍니다';
    }
    return null;
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void submit() async {
    setState(() {
      errorMessage = "";
    });

    if (validateAndSave()) {
      String userID = "";
      try {
        if (_isLoginForm) {
          userID = await widget.auth.signIn(_emailId, _password);
          print('LoginPage() : Email : $_emailId, PW : $_password , userID : $userID');
        }
        if (userID.length > 0 && userID != null && _isLoginForm) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }
  @override
  void initState() {
    errorMessage = "";
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }
}
