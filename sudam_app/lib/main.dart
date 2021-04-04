import 'package:admob_flutter/admob_flutter.dart';
import 'package:exam_project_app/Page/ExamPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Info/ExamInfo.dart';

// 국어는 한 시험지에 선택사항으로 두파트를 고를수있음 시발좆됨
// 수학도 좆됨


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Color(0xff747474), //0xFF8e89ff , 0xff81a1ff
        fontFamily: 'Jua',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  _launchURL() async {
    const url = 'https://forms.gle/fYdencWkAgaqEr1N8';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '인터넷이 원할하지 않습니다.';
    }
  }

  // 버튼 위젯들을 배열로 만들어 편하게 관리 하는 방법 구상하는게 리팩토링 좋음
  @override
  Widget build(BuildContext context) {
    double minButtonWidth = MediaQuery.of(context).size.width * 0.2;
    double minButtonHeight = MediaQuery.of(context).size.height * 0.045;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: AppBar(
            title: Text(
              'Suneung bucket',
              style: TextStyle(fontFamily: 'Kalam', color: Colors.white, fontSize: 30),
              // Dancing_Script
              // Kalam
              // Yellowtail
              // Playball
            ),
            centerTitle: true,
            actions: [
              FlatButton(
                child: Text('오류 제보'),
                onPressed: () {
                  _launchURL();
                },
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 5.0, right: 5.0),
                child: Card(
                  shadowColor: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '공통 과목',
                              style: TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            children: [
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceBetween,
                                buttonMinWidth: minButtonWidth,
                                buttonHeight: minButtonHeight,
                                children: [
                                  objectButton("국어"),
                                  objectButton("수학(가)"),
                                  objectButton("수학(나)"),
                                  objectButton("영어"),
                                ],
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceBetween,
                                buttonMinWidth: minButtonWidth,
                                buttonHeight: minButtonHeight,
                                children: [
                                  objectButton("한국사"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 5.0, right: 5.0),
                child: Card(
                  shadowColor: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '과학 탐구',
                              style: TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            children: [
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceBetween,
                                buttonMinWidth: minButtonWidth,
                                buttonHeight: minButtonHeight,
                                children: [
                                  objectButton("물리I"),
                                  objectButton("화학I"),
                                  objectButton("생명과학I"),
                                  objectButton("지구과학I"),
                                ],
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceBetween,
                                buttonMinWidth: minButtonWidth,
                                buttonHeight: minButtonHeight,
                                children: [
                                  objectButton("물리II"),
                                  objectButton("화학II"),
                                  objectButton("생명과학II"),
                                  objectButton("지구과학II"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 5.0, right: 5.0),
                child: Card(
                  shadowColor: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '사회 탐구',
                              style: TextStyle(fontSize: 28),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceBetween,
                                buttonMinWidth: minButtonWidth,
                                buttonHeight: minButtonHeight,
                                children: [
                                  objectButton("경제"),
                                  objectButton("동아시아"),
                                  objectButton("사회문화"),
                                  objectButton("세계사"),
                                ],
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceBetween,
                                buttonMinWidth: minButtonWidth,
                                buttonHeight: minButtonHeight,
                                children: [
                                  objectButton("세계지리"),
                                  objectButton("윤리와사상"),
                                  objectButton("정치와법"),
                                  objectButton("한국지리"),
                                ],
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceBetween,
                                buttonMinWidth: minButtonWidth,
                                buttonHeight: minButtonHeight,
                                children: [
                                  objectButton("생활과윤리"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: AdmobBanner(
                  adUnitId: getBannerAdUnitId(),
                  adSize: AdmobBannerSize.LARGE_BANNER,
                  listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
                  onBannerCreated: (AdmobBannerController controller) {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget objectButton(String object) {
    return OutlineButton(
      child: Text(
        object,
        style: TextStyle(fontSize: 17),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ExamPage(examInfo: ExamInfo(object))));
      },
      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
      borderSide: BorderSide(color: Colors.black45, width: 0.9, style: BorderStyle.solid),
    );
  }
}

String getBannerAdUnitId() {
  return 'ca-app-pub-2659418845004468/3279112332';
}

String getInterstitialAdUnitId() {
  return 'ca-app-pub-2659418845004468/4458432254';
}
