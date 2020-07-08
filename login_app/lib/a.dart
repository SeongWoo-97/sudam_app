import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Todo{
  bool isDone = false;
  String title;

  Todo(this.title);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo list',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final _itmes = <Todo>[];
  var _todoController = TextEditingController();

  @override
  void dispose(){
    _todoController.dispose();
    super.dispose();
  }
  void _addTodo(Todo todo){ //할일 추가 메서드
    setState(() {
      _itmes.add(todo);
      _todoController.text = '';
    });
  }
  void _deleteTodo(Todo todo){ //할일 삭제 메서드
    setState(() {
      _itmes.remove(todo);
    });
  }
  void _toggleTodo(Todo todo){ //할일 완료/미완료 메서드
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('남은 할 일'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _todoController,
                ),
              ),
              RaisedButton(
                child: Text('추가'),
                onPressed: () => _addTodo(Todo(_todoController.text)),
              )
            ],),
            Expanded(
              child: ListView(
                children: _itmes.map((todo) => _buildItemWidget(todo)).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildItemWidget(Todo todo){
    return ListTile(
      onTap: () => _toggleTodo(todo), // Todo : 클릭시 완료/취소 되도록 수정
      title: Text(
        todo.title, // 할 일
        style: todo.isDone // 완료일 때는 스타일 적용
            ? TextStyle(
          decoration: TextDecoration.lineThrough, //취소선
          fontStyle: FontStyle.italic, //이탤릭체
        )
            :null, //아무 스타일도 적용 안함
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: () => _deleteTodo(todo), // Todo:쓰레기통 클릭시 삭제되도록 수정
      ),
    );
  }
}
