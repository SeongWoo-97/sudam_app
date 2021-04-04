import 'package:exam_project_app/Info/ExamInfo.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class ExplainModePage extends StatefulWidget {
  final ExamInfo examInfo;
  final savePath;
  final previousPage;

  ExplainModePage({this.examInfo, this.savePath, this.previousPage});

  @override
  _ExplainModePageState createState() => _ExplainModePageState();
}

class _ExplainModePageState extends State<ExplainModePage> {
  PdfController _pdfController;
  int _actualPageNumber;
  int _allPagesCount = 0;

  @override
  void initState() {
    _pdfController = PdfController(document: PdfDocument.openFile(widget.savePath), initialPage: widget.previousPage);
    super.initState();
    // print('widget.previousPage = ${widget.previousPage}');
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: SafeArea(
          child: AppBar(
            title: Text('해설지'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // print("Page : $_actualPageNumber");
                Navigator.pop(context, _actualPageNumber);
              },
            ),
          ),
        ),
      ),
      body: PdfView(
        controller: _pdfController,
        pageBuilder: (PdfPageImage pageImage, bool isCurrentIndex, AnimationController animationController) {
          final List<double> _doubleTapScales = <double>[1.0, 2.0, 3.0];

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
        // onDocumnetLoaded 후에 image 생성
        onDocumentLoaded: (document) {
          setState(() {
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
