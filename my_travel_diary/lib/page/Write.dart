import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Write extends StatefulWidget {
  @override
  _WriteState createState() => _WriteState();
}

class _WriteState extends State<Write> {
  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  final writing = TextEditingController();
  String _error = 'No Error Dectected';
  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return SizedBox(
      height: 120,
      width: 500,
      child: new ListView.builder(
        scrollDirection: Axis.horizontal, // 스크롤 방향
        itemBuilder: (BuildContext context, int index) =>
        new Padding(
            padding: const EdgeInsets.only(top: 20,left: 20),
            child : Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: AssetThumb(
                  asset: images[index],
                  height: 200,
                  width: 200,
                ),
              ),
            )
        ),
        itemCount: images.length, // 이미지 갯수
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('글쓰기 Page'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.send),
              onPressed: (){
                writeSumit;
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            images.length > 0
                ? buildGridView()
                : photoNone,
            writeBox,
          ],
        ));
  }

  Widget get photoNone => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 25, left: 20),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '사진 올리기',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.black54),
                      iconSize: 30,
                      onPressed: () {
                        loadAssets();
                      },
                    )
                  ],
                ),
              )),
        ],
      );
  Widget get writeBox => Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 20),
            child: Container(
                width: 375,
                height: 170,
                decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: TextField(
                  controller: writing,
                  decoration: new InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    hintText: '내용 입력',
                  ),
                  maxLines: 5,
                  maxLength: 150,
                )),
          )
        ],
      );
  //지도 추가하기
  Widget get writeSumit => null;
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Upload Image",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
  }

}
