import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShowText extends StatefulWidget {
  String text;
  ShowText(this.text);
  @override
  _ShowTextState createState() => _ShowTextState(text);
}

class _ShowTextState extends State<ShowText> {
  String text;
  _ShowTextState(this.text);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [ Colors.greenAccent[400],Colors.black])),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height*0.7,
            width: MediaQuery.of(context).size.width*0.9,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              border: Border.all(color: Colors.greenAccent,width: 2),
            ),
            child: Container(
              margin: EdgeInsets.all(10),
              child: SelectableText(
                text,style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    floatingActionButton: FloatingActionButton(
    backgroundColor: Colors.greenAccent[400],
    child: Icon(Icons.content_copy,color: Colors.white,),
      onPressed: (){
      Clipboard.setData(ClipboardData(text: text));
      Fluttertoast.showToast(
          msg:
          "Copied to Clipboard",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent[400],
          textColor: Colors.white,
          fontSize: 16.0);
      },
    ),
    );
  }
}
