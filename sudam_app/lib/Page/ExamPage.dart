import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:exam_project_app/Info/ExamInfo.dart';
import 'package:exam_project_app/Info/year.dart';
import 'package:exam_project_app/Mode/ReadModePage.dart';
import 'package:exam_project_app/main.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class ExamPage extends StatefulWidget {
  final ExamInfo examInfo;

  ExamPage({this.examInfo});

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final Dio _dio = Dio();
  var savePath;

  bool _loading;
  int _year, _month, nowYear, nowMonth;
  String objectName, folderName;
  ProgressDialog progressDialog;
  AdmobInterstitial interstitialAd;
  List<Year> _years = generateItems(yearList.length);

  @override
  void initState() {
    super.initState();
    _loading = true;
    nowYear = DateTime.now().year;
    nowMonth = DateTime.now().month;
    objectName = widget.examInfo.objectName;
    folderName = widget.examInfo.folderName;
    Admob.requestTrackingAuthorization();
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    Future.delayed(Duration(milliseconds: 550), () {
      setState(() {
        _loading = false;
      });
    });
    interstitialAd.load();
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }

  Future<bool> _internetCheck() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<void> _download(int year, int month) async {
    final dir = await getApplicationDocumentsDirectory();
    final isPermissionStatusGranted = await _requestPermissions();
    if (isPermissionStatusGranted) {
      // print("savePath : " + savePath);
      // perStatus = true;
      savePath = path.join(dir.path, objectName, "$year" + "_" + "$month" + "월_$objectName.pdf");
      await _startDownload(savePath, year, month);
    } else {
      // perStatus = false;
    }
  }

  Future<void> _startDownload(String savePath, int year, int month) async {
    if (await File(savePath).exists()) {
    } else {
      // print('다운로드 주소 : ${objectUrl['$objectName']}/${folderName}_${year}_$month.pdf');
      await _dio.download('${objectUrl['$objectName']}/${folderName}_${year}_$month.pdf', savePath, deleteOnError: true);
    }
  }

  Future<bool> _requestPermissions() async {
    var permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions(([PermissionGroup.storage]));
      permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    }
    return permission == PermissionStatus.granted;
  }

  _launchURL() async {
    const url = 'https://forms.gle/1zte4T1Mpm1CP5yA9';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '인터넷이 원할하지 않습니다.';
    }
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context, type: ProgressDialogType.Normal, textDirection: TextDirection.rtl, isDismissible: true, showLogs: false);
    progressDialog.style(
      message: '...불러오는중',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      progressWidgetAlignment: Alignment.center,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: AppBar(
            title: Text('$objectName 시험지 선택'),
            centerTitle: true,
            actions: [
              FlatButton(
                  child: Text('시험지 오류신고'),
                  onPressed: () {
                    _launchURL();
                  }),
            ],
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      child: ExpansionPanelList.radio(
                        animationDuration: Duration(milliseconds: 540),
                        children: _years.map<ExpansionPanelRadio>((Year year) {
                          return ExpansionPanelRadio(
                            value: year.id,
                            headerBuilder: (BuildContext context, bool isExpanded) {
                              return ListTile(
                                title: Text(year.headerValue),
                              );
                            },
                            body: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.separated(
                                itemCount: monthList.length,
                                // 과탐 II 영역은 3월시험지 없음
                                itemBuilder: (context, index) {
                                  _year = yearList[year.id];
                                  _month = monthList[index];

                                  if (((objectName.contains("II")) && (_month == 3)) || ((_year >= nowYear) && (_month > nowMonth))) {
                                    return ListTile(
                                      title: _month != 11 ? Text('$_month월 $objectName 모의고사') : Text("$objectName 수능 시험지"),
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Row(
                                                children: [
                                                  Icon(
                                                    Icons.warning_amber_outlined,
                                                    size: 25,
                                                    color: Colors.red,
                                                  ),
                                                  Text('준비중'),
                                                ],
                                              ),
                                              content: Text('시험이 실시되지 않았습니다.'),
                                              actions: [
                                                FlatButton(
                                                  child: Text('확인'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  } else
                                    return ListTile(
                                      title: _month != 11 ? Text('$_month월 $objectName 모의고사') : Text("$objectName 수능 시험지"),
                                      onTap: () async {
                                        if (await _internetCheck()) {
                                          if (await _requestPermissions()) {
                                            await progressDialog.show();
                                            if (await interstitialAd.isLoaded) {
                                              interstitialAd.show();
                                            }
                                            await _download(yearList[year.id], monthList[index]);
                                            progressDialog.hide();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ReadModePage(
                                                  savePath: savePath,
                                                  examInfo: ExamInfo(objectName, year: yearList[year.id], month: monthList[index]),
                                                ),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('파일 관리자 권한없음'),
                                                  content: Text('파일 관리자 권한이 없어 PDF 파일을 불러올 수가 없습니다.'),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text('확인'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.warning_amber_outlined,
                                                      size: 25,
                                                      color: Colors.red,
                                                    ),
                                                    Text('네트워크 연결확인'),
                                                  ],
                                                ),
                                                content: Text('네트워크가 연결되어있지 않습니다 !'),
                                                actions: [
                                                  FlatButton(
                                                    child: Text('확인'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    thickness: 2,
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList(),
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
    );
  }
// bool dateCheck(int year, int month, int index) {
//   print("$year,$month,$index");
//   return false;
// }
}
