import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ScanDocument extends StatefulWidget {
  @override
  _ScanDocumentState createState() => _ScanDocumentState();
}

class _ScanDocumentState extends State<ScanDocument> {
  final pdf = pw.Document();
  TextEditingController fname=TextEditingController();
  File _image, _cropped_file, _editFile;
  var imgconfig;
  final picker = ImagePicker();
  List<File> img = [];
  List<bool> selected = [];
  List<int> indexes = [];
  bool select = false;

  Future getImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
    _cropped_file = await ImageCropper.cropImage(
        //maxHeight:PdfPageFormat.a4.height.toInt(),
        //maxWidth: PdfPageFormat.a4.width.toInt(),
        sourcePath: _image.path,
        compressQuality: 100,
        aspectRatioPresets:
        [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.greenAccent[400],
            activeControlsWidgetColor: Colors.greenAccent[400],
            cropFrameColor: Colors.white,
            backgroundColor: Colors.white,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      if (_cropped_file != null) {
        img.add(_cropped_file);
        selected.add(false);
      }
    });
  }

  Future updateImage(int index) async {
    _editFile = await ImageCropper.cropImage(
        sourcePath: img[index].path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            cropFrameColor: Colors.white,
            toolbarColor: Colors.greenAccent[400],
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    setState(() {
      if (_editFile != null) {
        img[index] = _editFile;
      }
    });
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
                    fit: BoxFit.fill, image: FileImage(img[index]))),
          ),
        ),
      ),
    );
  }

 Future createPdf() async{
    img.forEach((element)async {
      //var imgconfig= await decodeImageFromList(element.readAsBytesSync());
      //imgconfig.height>PdfPageFormat.a4.height?print("yes"):print("no");
      var image = PdfImage.file(pdf.document, bytes: element.readAsBytesSync());
      try {
        pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.undefined,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(image),
              ); // Center
            })); //
      }
      catch(e)
      {
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
          msg:
          "$fname_ successfully created at $docPath",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent[400],
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (e) {
      print(e+" is exception");
      Fluttertoast.showToast(
          msg:
          "Unexpected Eror please try again later :-(",
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
                      showDialog (
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
                                  onPressed: () async{
                                    if(fname.text!="")
                                      {
                                        print(fname);
                                        createPdf();
                                        await savePdf(fname.text);
                                        Navigator.of(context).pop();
                                      }
                                    else{
                                      Fluttertoast.showToast(
                                          msg:
                                          "FILENAME can't be empty :-( ",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.greenAccent[400],
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
                              "Your Dumbass didn't add any pages for me to make pdf with :-(",
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: _Pages,
            itemCount: img.length,
          )),
      floatingActionButton: Container(
        height: MediaQuery.of(context).size.width*0.18,
        width: MediaQuery.of(context).size.width*0.18,
        child: FloatingActionButton(
          backgroundColor: Colors.greenAccent[400],

          onPressed: (){
            getImage();
          },
          child: Text('+',
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.normal
          ),),
        ),
      ),
    );
  }
}
