import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'dart:async';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'text_show.dart';

class OcrPage extends StatefulWidget {
  @override
  _OcrPageState createState() => _OcrPageState();
}
Future getText(String p) async {
  WidgetsFlutterBinding.ensureInitialized();
  String text = await TesseractOcr.extractText(p, language: 'eng');
  return text;
}
class _OcrPageState extends State<OcrPage> {
  ImagePicker picker;
  File _image;
  String text;
  bool f = false;

  Future getImg() async {
    print(ImageSource.gallery);
    var picked_file;
    try {
      picked_file = await ImagePicker().getImage(source: ImageSource.gallery);
    } catch (e) {
      print("wtf");
      print(e);
    }
    _image = File(picked_file.path);
    _image = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [CropAspectRatioPreset.original],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.greenAccent[400],
            activeControlsWidgetColor: Colors.greenAccent[400],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
  }

  Widget Show_Waiting()
  {
    return Column(
      children: <Widget>[
        Spacer(),
        CircularProgressIndicator(),
        Text('Wait for the text to appear here........'),
        Spacer()
      ],
    );
  }
  show_wait_func(bool f)
  {
    if(f==true) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Wait for the text to appear here /n it might take a minute or more depending on image size'),
            );

          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR'),
        backgroundColor: Colors.greenAccent[400],
      ),
     /* body: Center(
        child: Container(
            child: f?Show_Waiting():null),),*/
      floatingActionButton: f?null:FloatingActionButton(
        backgroundColor: Colors.greenAccent[400],
        child: Icon(
          Icons.image,
          color: Colors.white,
        ),
        onPressed: () async {
          Timer(Duration(milliseconds: 500), () async{
            setState(() {
              f=true;
              compute(show_wait_func,f);
            });
          });
          await getImg();
          Timer(Duration(milliseconds: 10), () async{
            WidgetsFlutterBinding.ensureInitialized();
            
            final texti= getText(_image.path);
            texti.then((value){
              setState(() {
                f=false;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ShowText(value.toString());
              }));
            });

          });
        },
      ),
    );
  }
}
