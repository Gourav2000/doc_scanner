import 'package:doc_scanner/Archive.dart';
import 'package:doc_scanner/PdfReader.dart';
import 'package:flutter/material.dart';
import 'package:doc_scanner/ScanDocument.dart';
import 'package:doc_scanner/ScanID.dart';
import 'package:path_provider/path_provider.dart';
import 'package:doc_scanner/OCR.dart';
import 'ocr_.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Spacer(),
                  InkWell(
                    splashColor: Colors.yellow,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return ScanDocument();
                      }));
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.greenAccent[400]),
                      child: Container(
                        margin: EdgeInsets.only(left: 25),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.insert_drive_file,
                              color: Colors.white,
                            ),
                            Text(
                              ' Scan Document',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Spacer(),
                  InkWell(
                    splashColor: Colors.yellow,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return OcrPage();
                      }));
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.greenAccent[400]),
                      child: Container(
                        margin: EdgeInsets.only(left: 25),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.pageview,
                              color: Colors.white,
                            ),
                            Text(
                              ' OCR',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Spacer(),
                  InkWell(
                    splashColor: Colors.yellow,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return ScanId();
                      }));
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.greenAccent[400]),
                      child: Container(
                        margin: EdgeInsets.only(left: 25),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.perm_identity,
                              color: Colors.white,
                            ),
                            Text(
                              ' Scan Id',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Spacer(),
                  InkWell(
                    splashColor: Colors.yellow,
                    onTap: () async{
                      Directory documentDirectory=await getExternalStorageDirectory();
                      Navigator.push(context, MaterialPageRoute(builder: (context)
                      {
                        return Archive(documentDirectory);
                      }));
                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.greenAccent[400]),
                      child: Container(
                        margin: EdgeInsets.only(left: 25),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.archive,
                              color: Colors.white,
                            ),
                            Text(
                              ' Archive',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
