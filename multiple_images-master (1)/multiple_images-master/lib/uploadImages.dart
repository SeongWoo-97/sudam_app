import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:multiple_images/utils.dart';

class UploadImages extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;
  const UploadImages({Key key, this.globalKey}) : super(key: key);
  @override
  _UploadImagesState createState() => new _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  List<Asset> images = List<Asset>();
  List<String> imageUrls = <String>[];
  String _error = 'No Error Dectected';
  bool isUploading = false;
  int _current = 0;
  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            images.length > 0
                ? Text('사진존재')
                : InkWell(
              onTap: loadAssets,
              child: ThreeDContainer(
                width: 130,
                height: 50,
                backgroundColor: MultiPickerApp.navigateButton,
                backgroundDarkerColor: MultiPickerApp.background,
                child: Center(
                    child: Text(
                      "Pick images",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            InkWell(
              onTap: () {
                if (images.length == 0) {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          backgroundColor:
                          Theme.of(context).backgroundColor,
                          content: Text("No image selected",
                              style: TextStyle(color: Colors.white)),
                          actions: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: ThreeDContainer(
                                width: 80,
                                height: 30,
                                backgroundColor:
                                MultiPickerApp.navigateButton,
                                backgroundDarkerColor:
                                MultiPickerApp.background,
                                child: Center(
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            )
                          ],
                        );
                      });
                } else {
                  SnackBar snackbar = SnackBar(
                      content: Text('Please wait, we are uploading'));
                  widget.globalKey.currentState.showSnackBar(snackbar);
                  uploadImages();
                }
              },
              child: ThreeDContainer(
                width: 130,
                height: 50,
                backgroundColor: MultiPickerApp.navigateButton,
                backgroundDarkerColor: MultiPickerApp.background,
                child: Center(
                    child: Text(
                      "Upload Images",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ],
        ),
        Container(
          color: Colors.white,
          height: 30,
        ),
        Expanded(child: buildGridView()),
      ],
    );
  }

  void uploadImages() {
    for (var imageFile in images) {
      postImage(imageFile).then((downloadUrl) {
        imageUrls.add(downloadUrl.toString());
        if (imageUrls.length == images.length) {
          String documnetID = DateTime.now().millisecondsSinceEpoch.toString();
          Firestore.instance
              .collection('images')
              .document(documnetID)
              .setData({'urls': imageUrls}).then((_) {
            SnackBar snackbar =
                SnackBar(content: Text('Uploaded Successfully'));
            widget.globalKey.currentState.showSnackBar(snackbar);
            setState(() {
              images = [];
              imageUrls = [];
            });
          });
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

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

  Future<dynamic> postImage(Asset imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask =
        reference.putData((await imageFile.getByteData()).buffer.asUint8List());
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    print(storageTaskSnapshot.ref.getDownloadURL());
    return storageTaskSnapshot.ref.getDownloadURL();
  }
}
