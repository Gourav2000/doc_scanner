import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doc_scanner/ApplyFilters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ScanId extends StatefulWidget {
  @override
  _ScanIdState createState() => _ScanIdState();
}

class _ScanIdState extends State<ScanId> {
  final pdf = pw.Document();
  TextEditingController fname = TextEditingController();
  File _image;
  var _cropped_file, _editFile;
  var imgconfig;
  final picker = ImagePicker();
  List img = [];
  List<bool> selected = [];
  List<int> indexes = [];
  bool select = false;

  Future getImage(source) async {
    var pickedFile = await picker.getImage(source: source);
    setState(() {
      _image = File(pickedFile.path);
    });
    var x = await _image.length();
    if (x > 3000000) {
      while (x ~/ 10 != 0) {
        x = x ~/ 10;
      }
      x = x ~/ 2;
    } else {
      x = 2;
    }
    var bytes = await testCompressFile(_image, x);
    String base64 = base64Encode(bytes);
    _cropped_file = await get_it_cropped(base64);

    if (_cropped_file != null) {
      _cropped_file = await ApplyFilters(context, _cropped_file.readAsBytesSync(), _image);
      if (_cropped_file != null) {
        setState(() {
          img.add(_cropped_file);
          selected.add(false);
          _cropped_file = null;
        });
      }
    }
    else{
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent[400],
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<Uint8List> testCompressFile(File file, int x) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      inSampleSize: x,
      quality: 70,
      rotate: 0,
    );
    print(file.lengthSync());
    print(result.length);
    return result;
  }

  Future updateImage(int index) async {
    _editFile = await get_it_cropped(img[index]);

    if (_editFile != null) {
      _editFile = await ApplyFilters(context, _editFile, _image);
      if (_editFile != null) {
        setState(() {
          img[index] = _editFile;
          _editFile = null;
        });
      }
    }
    else{
      Fluttertoast.showToast(
          msg: "Something went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent[400],
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  get_it_cropped( img) async {
    var _cropped_photo=await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            activeControlsWidgetColor: Colors.greenAccent[400],
            toolbarColor: Colors.greenAccent[400],
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );
    if(_cropped_photo!=null){

      return _cropped_photo;
    }
    else{
      return null;
    }
  }

  Widget _Pages(BuildContext context, int index) {
    return InkWell(
      splashColor: Colors.blue,
      onLongPress: () {
        setState(() {
          selected[index] = true;
          select = true;
        });
      },
      onTap: () {
        setState(() {
          select ? selected[index] = !selected[index] : updateImage(index);
        });
      },
      child: Container(
        margin: EdgeInsets.all(2),
        color: selected[index] ? Colors.lightBlueAccent : Colors.transparent,
        child: Center(
          child: Container(
            height: 160,
            width: 160,
            //margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent[400], width: 2),
                image: DecorationImage(
                    fit: BoxFit.fill, image: MemoryImage(img[index]))),
          ),
        ),
      ),
    );
  }

  Future createPdf() async {
    img.forEach((element) async {
      //var imgconfig= await decodeImageFromList(element.readAsBytesSync());
      //imgconfig.height>PdfPageFormat.a4.height?print("yes"):print("no");
      var image = PdfImage.file(pdf.document, bytes: element);
      try {
        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.undefined,
            build: (pw.Context context) {
              return pw.Center(child: pw.Image(image)); // Center
            })); //
      } catch (e) {
        print("wtf");
      }
    });
  }

  Future savePdf(String fname_) async {
    Directory documentDirectory = await getExternalStorageDirectory();
    String docPath = documentDirectory.path;
    try {
      File pfile = File("$docPath/$fname_.pdf");
      pfile.writeAsBytesSync(pdf.save());
      print(docPath);
      Fluttertoast.showToast(
          msg: "$fname_ successfully created at $docPath",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent[400],
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e + " is exception");
      Fluttertoast.showToast(
          msg: "Unexpected Error please try again later :-(",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent[400],
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        actions: <Widget>[
          select
              ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  select = false;
                  selected.fillRange(0, selected.length, false);
                });
              })
              : Container(),
          Spacer(),
          select
              ? IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              for (int i = 0; i < selected.length; ++i) {
                if (selected[i] == true) {
                  setState(() {
                    indexes.add(i);
                    selected[i] = false;
                  });
                }
              }
              for (int i = 0; i < indexes.length; ++i) {
                setState(() {
                  img.removeAt(indexes[i] - i);
                });
              }
              setState(() {
                select = false;
                indexes.clear();
              });
            },
          )
              : IconButton(
            icon: Icon(
              Icons.picture_as_pdf,
            ),
            onPressed: () async {
              if (img.length != 0) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("What will be the pdf file name..??"),
                        content: TextFormField(
                          obscureText: false,
                          keyboardType: TextInputType.text,
                          controller: fname,
                          decoration:
                          InputDecoration(hintText: "Enter here"),
                        ),
                        actions: <Widget>[
                          RaisedButton(
                            onPressed: () async {
                              if (fname.text != "") {
                                print(fname);
                                createPdf();
                                await savePdf(fname.text);
                                Navigator.of(context).pop();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "FILENAME can't be empty :-( ",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                    Colors.greenAccent[400],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: Text('Ok'),
                          ),
                        ],
                      );
                    });
              } else {
                Fluttertoast.showToast(
                    msg:
                    "You didn't add any pages for me to make pdf with :-(",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.greenAccent[400],
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
          ),
        ],
        leading: select ? new Container() : null,
      ),
      body: Container(
          child: GridView.builder(
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: _Pages,
            itemCount: img.length,
          )),
      floatingActionButton: Container(
        height: MediaQuery.of(context).size.width * 0.18,
        width: MediaQuery.of(context).size.width * 0.18,
        child: FloatingActionButton(
          backgroundColor: Colors.greenAccent[400],
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Choose your preference"),
                  content:
                  SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        InkWell(
                          splashColor: Colors.greenAccent[400],
                          onTap: () {
                            getImage(ImageSource.camera);
                            Navigator.of(context).pop();
                          },
                          child: Row(children: <Widget>[Icon(Icons.camera_alt),Text(' Camera')],),),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 10,
                                bottom: 10
                            ),
                            child:Container(
                              height:1.0,
                              width:130.0,
                              color:Colors.grey,)
                        ),
                        InkWell(
                          splashColor: Colors.greenAccent[400],
                          onTap: () {
                            getImage(ImageSource.gallery);
                            Navigator.of(context).pop();
                          },
                          child: Row(children: <Widget>[Icon(Icons.image),Text(' Gallery')],),),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Text(
            '+',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
