import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:goalapp/Utils/database_helper.dart';
import 'package:goalapp/module/goal.dart';
import 'package:goalapp/module/index.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;
  List<Goal> goalList;

  @override
  Widget build(BuildContext context) {
    Index currentIndex = Provider.of<Index>(context);

    if (goalList == null) {
      goalList = List<Goal>();
      print('updateListView 실행');
      updateListView();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('목표 리스트'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            currentIndex.currentIndex = 0;
          },
          child: Icon(Icons.add),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                itemCount: count,
                itemBuilder: (BuildContext context,int index) {
                  return Slidable(
                    secondaryActions: <Widget>[
                      IconSlideAction(
                          icon: Icons.delete,
                          color: Colors.red,
                          caption: 'Delete',
                          onTap: () {
                            setState(() {
                              _delete(context, this.goalList[index]);
                              // goal.goalList.removeAt(index);
                            });
                          })
                    ],
                    actionPane: SlidableStrechActionPane(),
                    child: Container(
                      child: ListTile(
                        title: this.goalList[index].getName != null
                            ? Text(this.goalList[index].getName)
                            : null,
                        subtitle: this.goalList[index].getDate2 != null
                            ? Row(
                                children: <Widget>[
                                  Text(this.goalList[index].getDate1),
                                  Text('~'),
                                  Text(this.goalList[index].getDate2),
                                ],
                              )
                            : null,
                        trailing: CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 5.0,
                          percent: this.goalList[index]
                                      .convertDateFromString() >=
                                  1.0
                              ? 1.0
                              : this.goalList[index].convertDateFromString(),
                          // 현재시간 - 시작일 / 종료일 - 시작일
                          center: this.goalList[index]
                                      .convertDateFromString() >=
                                  1.0
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                      Text('100'),
                                      Text('%'),
                                    ])
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                      Text((this.goalList[index]
                                                  .convertDateFromString() *
                                              100)
                                          .toInt()
                                          .toString()),
                                      Text('%'),
                                    ]),
                          progressColor: Colors.green,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(thickness: 1.5);
                },
              ),
            ),
            RaisedButton(
              child: Text('확인'),
              onPressed: () {
                print('length : ${this.goalList.length}');
              },
            )
          ],
        ));
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Goal>> goalListFuture = databaseHelper.getGoalList();
      goalListFuture.then((goalList) {
        setState(() {
          this.goalList = goalList;
          this.count = goalList.length;
          print('update goal length : ${this.goalList.length}');
        });
      });
    });
  }

  void _delete(BuildContext context, Goal goal) async {
    int result = await databaseHelper.deleteGoal(goal.id);
    if (result != 0) {
      _showSnackBar(context, 'Todo Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
