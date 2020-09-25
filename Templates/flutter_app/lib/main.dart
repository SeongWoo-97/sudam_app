import 'package:flutter/material.dart';
import 'package:flutter_app/exampaper.dart';
import 'package:flutter_app/object.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '모의고사 홈페이지',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Object> objectList = generateObjects(names);
  List<Year> yearList = generateYears(year);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모의고사 메인화면'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          objectList[index].isExpanded = !isExpanded;
        });
      },
      children: objectList.map<ExpansionPanel>((Object object) {
        return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(object.name),
              );
            },
            body: SingleChildScrollView(
              child: Container(
                child: _yearPanel(object),
              ),
            ),
            isExpanded: object.isExpanded);
      }).toList(),
    );
  }

  Widget _yearPanel(Object object) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          yearList[index].isExpanded = !isExpanded;
        });
      },
      children: yearList.map<ExpansionPanel>((Year year) {
        return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text('${year.year}'),
              );
            },
            body: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView.separated(
                  itemCount: month.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    thickness: 2.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('${month[index]}월 국어 모의고사'),
                      onTap: () {
                        print(
                            "${object.name},${year.year},${month[index]}월 선택");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExamPaper()));
                      },
                    );
                  },
                ),
              ),
            ]),
            isExpanded: year.isExpanded);
      }).toList(),
    );
  }
}
