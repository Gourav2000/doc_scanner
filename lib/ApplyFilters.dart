import 'package:photofilters/photofilters.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as imageLib;

ApplyFilters(context,_imageArray,_image)async{
  var image = imageLib.decodeImage(_imageArray);
  image = imageLib.copyResize(image, width: 600);
  String fileName=basename(_image.path);
  var l=presetFiltersList;
  if(l.length!=12){
    l.removeAt(2);
    l.removeAt(3-1);
    l.removeAt(4-2);
    l.removeAt(5-3);
    l.removeAt(7-4);
    l.removeAt(8-5);
    l.removeAt(9-6);
    l.removeAt(10-7);
    l.removeAt(12-8);
    l.removeAt(13-9);
    l.removeAt(14-10);
    l.removeAt(17-11);
    l.removeAt(18-12);
    l.removeAt(20-13);
    l.removeAt(21-14);
    l.removeAt(24-15);
    l.removeAt(25-16);
    l.removeAt(26-17);
    l.removeAt(27-18);
    l.removeAt(28-19);
    l.removeAt(29-20);
    l.removeAt(30-21);
    l.removeAt(31-22);
    l.removeAt(32-23);
    l.removeAt(33-24);
    l.removeAt(34-25);
    l.removeAt(35-26);
    l.removeAt(37-27);
    l.removeAt(38-28);
    l.removeAt(39-29);
    l.removeAt(40-30);
  }
  for(int i=0;i<presetFiltersList.length;++i)
    {
      print(i);
      print(presetFiltersList[i]);
    }
  Map imagefile = await Navigator.push(
    context,
    new MaterialPageRoute(
      builder: (context) => new PhotoFilterSelector(
        title: Text("Photo Filter Example"),
        image: image,
        appBarColor: Colors.greenAccent[400],
        filters: presetFiltersList,
        filename: fileName,
        loader: Center(child: CircularProgressIndicator()),
        fit: BoxFit.contain,
      ),
    ),
  );
  if (imagefile != null && imagefile.containsKey('image_filtered')) {
      _image = imagefile['image_filtered'];
      return _image.readAsBytesSync();
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
    return null;
  }
}