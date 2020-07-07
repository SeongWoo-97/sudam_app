import 'package:mytraveldiary/images/icon.dart';
import 'package:flutter/material.dart';

class FindPW extends StatefulWidget {
  @override
  _FindPWState createState() => _FindPWState();
}

class _FindPWState extends State<FindPW> {
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
                    width: 261,
                    height: 235,
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        emailInput,
                        SizedBox(height: 20),
                        mailButton,
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

  Widget get emailInput => Container(
      width: 250,
      height: 50,
      child: TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: InputDecoration(
            hintText: '아이디 생성당시 적으신 이메일 입력',
            hintStyle: TextStyle(
                fontSize: 12, height: 3.5, fontWeight: FontWeight.bold),
            prefixIcon: UserIcon(),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
      ),
    );

  Widget get mailButton => RaisedButton(
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Text(
        '이메일에 임시비밀번호 보내기',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed: () {},
    );
}
