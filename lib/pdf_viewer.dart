// import 'dart:io';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatelessWidget {
  PdfViewer({required this.path, required this.fileName});
  final path;
  String fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
      ),
      body: Container(
        // constraints: const BoxConstraints(maxHeight: 500, maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfPdfViewer.network(
            path,
            enableDoubleTapZooming: true,
            canShowHyperlinkDialog: true,
            // canShowPageLoadingIndicator: false,
            canShowScrollHead: true,
            canShowPaginationDialog: false,
            // undoController: UndoHistoryController(),
            // initialPageNumber: 10,
          ),

          // File(
          //   '/Users/chetanr/Library/Developer/CoreSimulator/Devices/5CBB732B-6557-42E0-BEA6-687D1B4DE80E/data/Containers/Data/Application/DA1F9458-356F-4E3A-B464-972747488445/tmp/First .pdf')),
        ),
      ),
    );
  }
}
