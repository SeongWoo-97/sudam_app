import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:goalapp/Utils/database_helper.dart';
import 'package:goalapp/module/goal.dart';
import 'package:goalapp/module/index.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

// 객체를 만들 클래스를 생성
// 생성된 객체를 내부저장소에 저장
class _FirstPageState extends State<FirstPage> {
  final _formKey = GlobalKey<FormState>();
  DatabaseHelper helper = DatabaseHelper();
  TextEditingController _names = TextEditingController();
  TextEditingController _message = TextEditingController();
  final values = List.filled(7, false);
  DateTime dateTime1 = DateTime.now();
  DateTime dateTime2;
  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;
  @override
  void dispose() {
    _names.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Index currentIndex = Provider.of<Index>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('목표 추가하기'),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10.0, right: 8.0),
              child: Text(
                '완료',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () {
              String date1 = DateFormat('yyyy.MM.dd').format(dateTime1);
              String date2 = DateFormat('yyyy.MM.dd').format(dateTime2);
              Goal newGoal = Goal(_names.text,
                  date1: date1,
                  date2: date2,
                  dateTime1: dateTime1,
                  dateTime2: dateTime2);
                  // goal.addGoalInList(newGoal);
              currentIndex.currentIndex = 1;
              _save(newGoal);
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding:
              const EdgeInsets.only(right: 10, left: 10, top: 20, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: TextFormField(
                        controller: _names,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            filled: true,
                            hintText: 'Todo Name',
                            hintStyle: TextStyle(fontSize: 15.0)),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text('시작일 :'),
                  FlatButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2020, 7, 20),
                            maxTime: DateTime(2021, 7, 23),
                            theme: DatePickerTheme(
                                headerColor: Colors.blue,
                                backgroundColor: Colors.white,
                                itemStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18),
                                doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16)), onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          setState(() {
                            dateTime1 = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.ko);
                      },
                      child: dateTime1 != null
                          ? Text(DateFormat('yyyy.MM.dd').format(dateTime1))
                          : Text(
                              DateFormat('yyyy.MM.dd').format(DateTime.now()))),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text('종료일 :'),
                  FlatButton(
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: dateTime1,
                            maxTime: DateTime(2022, 12, 31),
                            theme: DatePickerTheme(
                                headerColor: Colors.blue,
                                backgroundColor: Colors.white,
                                itemStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18),
                                doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16)), onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          setState(() {
                            dateTime2 = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.ko);
                      },
                      child: dateTime2 != null
                          ? Text(DateFormat('yyyy.MM.dd').format(dateTime2))
                          : Text('종료일을 선택하기')),
                ],
              ),
              Row(
                children: <Widget>[
                  Text('활동 일수 : '),
                  dateTime1 != null && dateTime2 != null
                      ? Text(dateTime2.difference(dateTime1).inDays.toString())
                      : Text('시작일 과 종료일을 선택해야함')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save(Goal goal) async {
    int result;
    if (goal.id != null) {
      result = await helper.updateGoal(goal);
    } else {
      result = await helper.insertGoal(goal);
    }
    if (result != 0) {
      print('저장 성공');
    } else {
      print('저장 실패');
    }
  }
  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Goal>> goalListFuture = databaseHelper.getGoalList();
      goalListFuture.then((goalList) {
        setState(() {
          Goal goal = Provider.of<Goal>(context, listen: false);
          goal.goalList = goalList;
          this.count = goalList.length;
          print('update goal length : ${goal.goalList.length}');
        });
      });
    });
  }
}
