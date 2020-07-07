import 'package:flutter/material.dart';
import 'package:mytraveldiary/service/RootPage.dart';
import 'package:mytraveldiary/service/authservice.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RootPage(auth: Auth()));
  }
}
