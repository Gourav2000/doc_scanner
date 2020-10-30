import 'package:doc_scanner/PdfReader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class Archive extends StatefulWidget {
  Directory documentDirectory;
  Archive(this.documentDirectory);
  @override
  _ArchiveState createState() => _ArchiveState(documentDirectory);
}

class _ArchiveState extends State<Archive> {
  Directory documentDirectory;
  List<String> sublist = new List<String>();
  List<String> fileList = new List<String>();
  List<DateTime> filetime = new List<DateTime>();
  File _file;
  _ArchiveState(this.documentDirectory);

  Widget dlistShow(BuildContext context, int index) {
    return InkWell(
      splashColor: Colors.greenAccent[400],
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)
        {
          return PdfReader(sublist[index],fileList[index]);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        ),
        padding: EdgeInsets.only(left: 2, right: 2, top: 16, bottom: 16),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.picture_as_pdf,
              size: 27,
              color: Colors.greenAccent[400],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '  ' + fileList[index],
                  style: TextStyle(fontSize: 19),
                ),
                Text(
                  '   '+DateFormat.Hm().format(filetime[index])+'  '+DateFormat.yMMMEd().format(filetime[index]),style: TextStyle(color: Colors.grey),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    documentDirectory
        .list(recursive: false, followLinks: false)
        .listen((FileSystemEntity entity) {
      setState(() {
        if (entity.path[entity.path.length - 1] == 'f' &&
            entity.path[entity.path.length - 2] == 'd' &&
            entity.path[entity.path.length - 3] == 'p') {
          sublist.add(entity.path);
          _file=File(entity.path);
          try{
          filetime.add(_file.lastModifiedSync());}catch(e){
            filetime.add(null);
          }
          fileList
              .add(entity.path.substring(documentDirectory.path.length + 1));
        }
        print(filetime);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Archive'),
          backgroundColor: Colors.greenAccent[400],
        ),
        body: ListView.builder(
          itemBuilder: dlistShow,
          itemCount: sublist.length,
        ));
  }
}
