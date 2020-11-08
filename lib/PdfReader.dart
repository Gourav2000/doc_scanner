import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_plugin.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:share/share.dart';

class PdfReader extends StatefulWidget {
  String docPath;
  String fname;
  PdfReader(this.docPath,this.fname);
  @override
  _PdfReaderState createState() => _PdfReaderState(docPath,fname);
}
class _PdfReaderState extends State<PdfReader> {
  String docPath,fname;
  _PdfReaderState(this.docPath,this.fname);
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text('$fname'),
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: (){
              Share.shareFiles(['$docPath']);
            },
          )
        ],
      ),
      path: '$docPath',
    );
  }
}
