import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Page/FirstPage.dart';
import 'NonePage/FourPage.dart';
import 'Page/SecondPage.dart';
import 'NonePage/ThirdPage.dart';
import 'module/goal.dart';
import 'module/index.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Index()),
        ChangeNotifierProvider(create: (_) => Goal('None')),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo App',
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var currentTab = [FirstPage(), SecondPage(), ThirdPage(), FourPage()];

  @override
  Widget build(BuildContext context) {
    Index currentIndex = Provider.of<Index>(context);
    return Scaffold(
      body: currentTab[currentIndex.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex.currentIndex,
        onTap: (index) {
          currentIndex.currentIndex = index;
        },
        type: BottomNavigationBarType.fixed,
        // 하단바 아이콘 고정
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), title: Text('Todo Create')),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted), title: Text('Todo List')),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text('none')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('none')),
        ],
        selectedItemColor: Colors.black87,
        // 선택된 index 색깔
        unselectedItemColor: Colors.black54,
        // 선택안된 index 색깔
      ),
    );
  }
}
