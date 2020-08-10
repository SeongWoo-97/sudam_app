import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final wordPair = WordPair.random(); // 랜덤 단어쌍 변수
  final List<WordPair> _list = <WordPair>[]; // 단어쌍을 저장할 list
  final TextStyle _textStyle = const TextStyle(fontSize: 18); // 단어쌍들의 TextStyle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i) {
          if(i.isOdd){ // Odd 홀수 , i가 홀수이면 Divider 구분선 반환
            return Divider(thickness: 2); //thickness 구분선 굵기
          }
          final int index = i ~/ 2;
          if(index >= _list.length) {
            _list.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_list[index]);
        });
  }
  Widget _buildRow(WordPair wordPair){
    return ListTile(
      title: Text(
        wordPair.asPascalCase,
        style: _textStyle,
      ),
    );
  }
}
