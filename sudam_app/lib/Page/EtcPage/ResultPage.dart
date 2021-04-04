import 'package:exam_project_app/Info/ExamInfo.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final List<String> pickList;
  final answerCount;
  final ExamInfo examInfo;

  ResultPage({this.pickList, this.answerCount, this.examInfo});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  int index = 0;
  List<DataRow> dataRows = [];
  List<int> questionAnswer = [];
  int numberOfAnswer = 0;
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < widget.answerCount; i++) {
      dataRows.add(DataRow(cells: [
        DataCell(Center(
            child: Text(
          (i + 1).toString() + '번',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jua', fontSize: 18),
        ))),
        // 자신의 정답
        DataCell(Center(
            child: Text(
          widget.examInfo.pickedList[i],
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jua', fontSize: 18),
        ))),
        // 답안정답 , korAnswer[year년month월]
        DataCell(Center(
            child: Text(
          widget.examInfo.questionAnswer[i].toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jua', fontSize: 18),
        ))),
        // 정답 여부 answerStatus 함수 사용
        DataCell(Center(child: answerStatus(i, widget.examInfo.pickedList[i], widget.examInfo.questionAnswer[i]))),
      ]));
    }
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _loading = false;
      });
    });
  }

  Text answerStatus(int i, String correntAnswer, var questionAnswer) {
    if (correntAnswer == questionAnswer.toString()) {
      numberOfAnswer += 1;
      return Text('O', style: TextStyle(color: Colors.green, fontFamily: 'Jua', fontSize: 18));
    } else {
      return Text('X', style: TextStyle(color: Colors.red, fontFamily: 'Jua', fontSize: 18));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: SafeArea(
            child: AppBar(
              title: Text('정답 결과'),
              centerTitle: true,
              actions: [],
            ),
          ),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '당신은 ${widget.examInfo.answerCount}문제 중 $numberOfAnswer문제를 맞히셨습니다!',
                          style: TextStyle(fontSize: 25),
                        ),
                      )
                    ]),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: SingleChildScrollView(
                        child: Center(
                          child: DataTable(columns: [
                            DataColumn(
                                label: Text(
                              '문제번호',
                              style: TextStyle(fontFamily: 'Jua'),
                            )),
                            DataColumn(
                                label: Text(
                              '본인 정답',
                              style: TextStyle(fontFamily: 'Jua'),
                            )),
                            DataColumn(
                                label: Text(
                              '답안',
                              style: TextStyle(fontFamily: 'Jua'),
                            )),
                            DataColumn(
                                label: Text(
                              '정답 여부',
                              style: TextStyle(fontFamily: 'Jua'),
                            )),
                          ], rows: dataRows),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
