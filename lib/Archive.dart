import 'package:doc_scanner/PdfReader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  List<bool> Selected = new List<bool>();
  int selected_count = 0;
  bool select = false;
  File _file;
  _ArchiveState(this.documentDirectory);

  Widget dlistShow(BuildContext context, int index) {
    return InkWell(
      highlightColor: Colors.greenAccent[400],
      splashColor: Colors.greenAccent[400],
      onLongPress: () {
        setState(() {
          Selected[index] = true;
          select = true;
        });
        selected_count = 0;
        for (var i in Selected) {
          if (i == true) {
            selected_count++;
          }
        }
      },
      onTap: () {
        setState(() {
          select
              ? Selected[index] = !Selected[index]
              : Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PdfReader(sublist[index], fileList[index]);
                }));
        });
        if (select == true) {
          bool z = false;
          selected_count = 0;
          for (var i in Selected) {
            if (i == true) {
              z = true;
              selected_count++;
            }
          }
          setState(() {
            select = z;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Selected[index] ? Colors.greenAccent : null,
          border: Border(bottom: BorderSide(width: 1, color: Colors.white)),
        ),
        padding: EdgeInsets.only(left: 2, right: 2, top: 16, bottom: 16),
        child: Row(
          children: <Widget>[
            Selected[index]
                ? Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.picture_as_pdf,
                    size: 27,
                    color: Colors.greenAccent[400],
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '  ' + fileList[index],
                  style: TextStyle(fontSize: 19,color: Colors.white),
                ),
                Text(
                  '   ' +
                      DateFormat.Hm().format(filetime[index]) +
                      '  ' +
                      DateFormat.yMMMEd().format(filetime[index]),
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
   FetchData(){
    setState(() {
      sublist.clear();
      Selected.clear();
      fileList.clear();
      filetime.clear();
      selected_count=0;
    });
    documentDirectory
        .list(recursive: false, followLinks: false)
        .listen((FileSystemEntity entity) {
      setState(() {
        if (entity.path[entity.path.length - 1] == 'f' &&
            entity.path[entity.path.length - 2] == 'd' &&
            entity.path[entity.path.length - 3] == 'p') {
          print('it working');
          setState(() {
            sublist.add(entity.path);
            Selected.add(false);
            _file = File(entity.path);
          });
          try {
            setState(() {
              filetime.add(_file.lastModifiedSync());
            });
          } catch (e) {
            setState(() {
              filetime.add(null);
            });
          }
          setState(() {
            fileList
                .add(entity.path.substring(documentDirectory.path.length + 1));
          });
        }
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: select
            ? AppBar(
                title: Text(
                  '$selected_count selected',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  child: Container(
                    color: Colors.greenAccent[400],
                    height: 1,
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    color: Colors.black,
                    onPressed: (){
                      List<String> FSelectedPaths=[];
                      for(int i=0;i<Selected.length;++i){
                        if(Selected[i]==true){
                          FSelectedPaths.add(sublist[i]);
                        }
                      }
                      Share.shareFiles(FSelectedPaths);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.black,
                    onPressed: () {
                      List<String> FSelectedPaths=[];
                      for(int i=0;i<Selected.length;++i){
                        if(Selected[i]==true){
                          FSelectedPaths.add(sublist[i]);
                        }
                      }
                      for(var i in FSelectedPaths ){
                        try{
                          File(i).delete(recursive: true);
                        }catch(e){
                          Fluttertoast.showToast(
                              msg: "Something went wrong plz try again!!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.greenAccent[400],
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      }
                      setState(() {
                        select=false;
                      });
                      FetchData();
                    },
                  ),
                ],
                leading: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      Selected.fillRange(0, Selected.length, false);
                      select = false;
                    });
                  },
                ),
              )
            : AppBar(
                title: Text('Archive'),
                backgroundColor: Colors.black,
              ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 2),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [ Colors.greenAccent[400],Colors.black])),
              child: ListView.builder(
                itemBuilder: dlistShow,
                itemCount: sublist.length,
              ),
            ),
          ),
        ));
  }
}
