import 'package:exam_project_app/Info/ExamInfo.dart';
import 'package:exam_project_app/Page/EtcPage/ResultPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_buttons/grouped_buttons.dart';

class AnswerPage extends StatefulWidget {
  final savePath;
  final ExamInfo examInfo;

  AnswerPage({this.savePath, this.examInfo});

  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  bool _loading = true;
  List<TextEditingController> _controller =
  List.generate(9, (index) => TextEditingController(text: '0'));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: AppBar(
            title: Text('답안선택'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if(widget.examInfo.objectName.contains("수학")){
                  for (int i = 0; i < 9; i++) {
                    widget.examInfo.pickedList[21 + i] = _controller[i].text;
                  }
                }
                Navigator.pop(context, widget.examInfo);
              },
            ),
            actions: [
              FlatButton(
                  child: Text('결과 보기',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  shape:
                  CircleBorder(side: BorderSide(color: Colors.transparent)),
                  textColor: Colors.white,
                  onPressed: () {
                    if(widget.examInfo.pickedList.contains(" ")) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('답안선택'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('정답이 선택되지 않은 문제가 있습니다! \n정답결과에는 답안지 정답이 공개되어있습니다'),
                              ],
                            ),
                            actions: [
                              FlatButton(
                                child: Text('결과보기'),
                                onPressed: () {
                                  if(widget.examInfo.objectName.contains("수학")){
                                    for (int i = 0; i < 9; i++) {
                                      widget.examInfo.pickedList[21 + i] = _controller[i].text;
                                    }
                                  }
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResultPage(
                                        pickList: widget.examInfo.pickedList,
                                        answerCount: widget.examInfo.answerCount,
                                        examInfo: widget.examInfo,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              FlatButton(
                                child: Text('돌아가기'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                            elevation: 5.0,
                          );
                        },
                      );
                    }
                    else {
                      if(widget.examInfo.objectName.contains("수학")){
                        for (int i = 0; i < 9; i++) {
                          widget.examInfo.pickedList[21 + i] = _controller[i].text;
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultPage(
                            pickList: widget.examInfo.pickedList,
                            answerCount: widget.examInfo.answerCount,
                            examInfo: widget.examInfo,
                          ),
                        ),
                      );
                    }
                  }),
            ],
            centerTitle: true,
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: ListView.builder(
          itemCount: widget.examInfo.answerCount,
          itemBuilder: (BuildContext context, int index) {
            return RadioButtonGroup(
              orientation: GroupedButtonsOrientation.HORIZONTAL,
              margin: const EdgeInsets.only(top: 15.0),
              onSelected: (String selected) => setState(() {
                widget.examInfo.pickedList[index] = selected;
                // print(widget.examInfo.pickedList);
              }),
              labels: <String>["1", "2", "3", "4", "5", "?"],
              picked: widget.examInfo.pickedList[index],
              itemBuilder: (Radio rb, Text txt, int i) {
                if (widget.examInfo.objectName.contains("수학") &&
                    index > 20) {
                  if (i == 0) {
                    return Row(
                      children: [
                        Text('${index + 1}.'),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Container(
                            width:
                            MediaQuery.of(context).size.width * 0.3,
                            height: 50,
                            child: TextFormField(
                              controller: _controller[index - 21],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                } else {
                  if (i == 0) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${index + 1}.'),
                        Column(
                          children: [txt, rb],
                        )
                      ],
                    );
                  }
                  return Column(
                    children: [txt, rb],
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
