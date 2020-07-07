import 'package:flutter/material.dart';
import 'Page/FirstPage.dart';
import 'Page/FourPage.dart';
import 'Page/SecondPage.dart';
import 'Page/ThirdPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goal App',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  final List<String> pageName = ["목표 추가하기","리스트 보기","달력 보기","설정"];
//  static const TextStyle optionStyle =
//      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
  PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
      // 어떻게 페이지 이동에 애니메이션 없이 바로 이동
      _pageController.animateToPage(index,
          duration: Duration(microseconds: 1), curve: Curves.linear);
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageName[_index]),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: <Widget>[
          FirstPage(),
          SecondPage(),
          ThirdPage(),
          FourPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // 하단바 아이콘 고정
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), title: Text('목표 추가하기')),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), title: Text('리스트 보기')),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text('달력 보기')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('설정')),
        ],
        currentIndex: _index,
        selectedItemColor: Colors.black87,
        // 선택된 index 색깔
        unselectedItemColor: Colors.black54,
        // 선택안된 index 색깔
        onTap: _onItemTapped, //
      ),
    );
  }
}
