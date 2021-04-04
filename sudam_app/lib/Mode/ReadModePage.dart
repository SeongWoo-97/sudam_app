import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:exam_project_app/Info/ExamInfo.dart';
import 'package:exam_project_app/Info/year.dart';
import 'package:exam_project_app/Mode/ExplainModePage.dart';
import 'package:exam_project_app/Page/EtcPage/AnswerPage.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class ReadModePage extends StatefulWidget {
  final savePath;
  final ExamInfo examInfo;

  ReadModePage({this.savePath, this.examInfo});

  @override
  _ReadModePageState createState() => _ReadModePageState();
}

class _ReadModePageState extends State<ReadModePage> {
  var savePath;
  final Dio _dio = Dio();
  ExamInfo examInfo;
  PdfController _pdfController;
  int _actualPageNumber = 1, _allPagesCount = 0;
  int previousPage = 1;
  String objectName, folderName;

  @override
  void initState() {
    super.initState();
    objectName = widget.examInfo.objectName;
    folderName = widget.examInfo.folderName;
    _pdfController = PdfController(document: PdfDocument.openFile(widget.savePath));
    examInfo = widget.examInfo;
  }

  @override
  void dispose() {
    _pdfController.dispose();
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
      // 파일저장 path
      savePath = path.join(
          dir.path,
          objectName + '해설지', //폴더명
          "$year" + "_" + "$month" + "월_$objectName + 해설지.pdf"); //파일명
      // print("savePath : " + savePath);
      await _startDownload(savePath, year, month);
    } else {}
  }

  Future<void> _startDownload(String savePath, int year, int month) async {
    if (await File(savePath).exists()) {
      // print('정답파일존재');
    } else {
      // 정답파일존재하지않으면
      // print(
      //     '다운로드 주소 : ${objectAnswerUrl['$objectName']}/${folderName}_explain_${year}_$month.pdf');
      // PDF 파일 주소 : https://kr.object.ncloudstorage.com/sudam/Common/math1/math1_2020_11.pdf
      // 정답 파일 주소 : https://kr.object.ncloudstorage.com/sudam/Common/math1_answer/math1_explain_2016_3.pdf
      // objectUrl =       https://kr.object.ncloudstorage.com/sudam/Common/math1
      // objectAnswerUrl = https://kr.object.ncloudstorage.com/sudam/Common/math1_answer
      await _dio.download('${objectAnswerUrl['$objectName']}/${folderName}_explain_${year}_$month.pdf', savePath, deleteOnError: true);
      // print('다운로드가 완료되었습니다.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: SafeArea(
          child: AppBar(
            title: Text('$_actualPageNumber/$_allPagesCount'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('읽기모드 종료'),
                      content: Text('정말로 종료하시겠습니까?'),
                      actions: [
                        FlatButton(
                          child: Text('네 종료합니다'),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text('아니요'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                      elevation: 5.0,
                    );
                  },
                );
              },
            ),
            actions: [
              // PDF 문제지 파일만 올라오고 정답확인 변수 업데이트가 안됐을시
              // 답안 선택하기 버튼 없음
              ButtonBar(
                children: [
                  widget.examInfo.questionAnswer.isNotEmpty
                      ? FlatButton(
                          child: Text("답안 선택하기"),
                          shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                          textColor: Colors.white,
                          onPressed: () async {
                            final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnswerPage(
                                          savePath: widget.savePath,
                                          examInfo: examInfo,
                                        )));
                            if (result != null) {
                              examInfo = result;
                              // print("ReadModePage : ${examInfo.pickedList}");
                            }
                          },
                        )
                      : Container(),
                  FlatButton(
                    child: Text("해설보기"),
                    shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
                    textColor: Colors.white,
                    onPressed: () async {
                      // print('해설보기 클릭');
                      // 인터넷이 연결되어 있어야지만 해설지 페이지로 넘어갈수 있음
                      if (await _internetCheck()) {
                        // print('인터넷 연결완료');
                        await _download(widget.examInfo.year, widget.examInfo.month);
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExplainModePage(
                                      examInfo: examInfo, //보고 있는 페이지 기록
                                      savePath: savePath,
                                      previousPage: previousPage,
                                    )));
                        if (result != null) {
                          previousPage = result;
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
                  ),
                ],
              ),
              // IconButton(
              //   icon: Icon(Icons.skip_previous),
              //   onPressed: () {
              //     _pdfController.jumpToPage(1);
              //   },
              // ),
              // IconButton(
              //   icon: Icon(Icons.skip_next),
              //   onPressed: () {
              //     _pdfController.jumpToPage(_pdfController.pagesCount);
              //   },
              // ),
            ],
          ),
        ),
      ),
      body: PdfView(
        controller: _pdfController,
        pageBuilder: (PdfPageImage pageImage, bool isCurrentIndex, AnimationController animationController) {
          // Double tap scales
          final List<double> _doubleTapScales = <double>[1.0, 2.0, 3.0];
          // Double tap animation
          Animation<double> _doubleTapAnimation;
          void Function() _animationListener;

          Widget image = ExtendedImage.memory(
            pageImage.bytes,
            key: Key(pageImage.hashCode.toString()),
            fit: BoxFit.fill,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (_) => GestureConfig(
              minScale: 1.15,
              maxScale: 2.0,
              animationMinScale: .75,
              animationMaxScale: 3.0,
              speed: 1,
              inertialSpeed: 100,
              inPageView: true,
              initialScale: 1.15,
              cacheGesture: false,
            ),
            onDoubleTap: (ExtendedImageGestureState state) {
              final pointerDownPosition = state.pointerDownPosition;
              final begin = state.gestureDetails.totalScale;
              double end;
              _doubleTapAnimation?.removeListener(_animationListener);
              animationController
                ..stop()
                ..reset();

              if (begin == _doubleTapScales[0]) {
                end = _doubleTapScales[1];
              } else {
                if (begin == _doubleTapScales[1]) {
                  end = _doubleTapScales[2];
                } else {
                  end = _doubleTapScales[0];
                }
              }
              _animationListener = () {
                state.handleDoubleTap(scale: _doubleTapAnimation.value, doubleTapPosition: pointerDownPosition);
              };
              _doubleTapAnimation = animationController.drive(Tween<double>(begin: begin, end: end))..addListener(_animationListener);
              animationController.forward();
            },
          );
          if (isCurrentIndex) {
            image = Hero(
              tag: 'pdf_view' + pageImage.pageNumber.toString(),
              child: image,
            );
          }
          return image;
        },
        onDocumentLoaded: (document) {
          setState(() {
            _actualPageNumber = 1;
            _allPagesCount = document.pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            _actualPageNumber = page;
          });
        },
        documentLoader: Center(
          child: CircularProgressIndicator(),
        ),
        pageLoader: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
