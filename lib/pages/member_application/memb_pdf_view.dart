// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:bseccs/models/masterModel.dart';

class PdfViewerPage extends StatefulWidget {
  PdfViewerPage(
      {super.key, required this.flag, required this.id, required this.bankId});
  String flag;
  String id;
  String bankId;

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late String localFilePath = "";
  String apiUrl = MasterModel.URL;

  @override
  void initState() {
    super.initState();
    downloadAndSavePdf();
  }

  Future<void> downloadAndSavePdf() async {
    try {
      var map = <String, dynamic>{};
      map['flag'] = widget.flag;
      map['id'] = widget.id;
      map['bank_id'] = widget.bankId;
      // Fetch the PDF from the API
      final response = await http.post(Uri.parse('$apiUrl/gen_pdf'), body: map);

      if (response.statusCode == 200) {
        // Get directory to save the PDF
        Directory dir = await getApplicationDocumentsDirectory();
        File file = File('${dir.path}/application_form.pdf');

        // Write the PDF to file
        await file.writeAsBytes(response.bodyBytes, flush: true);

        setState(() {
          localFilePath = file.path;
        });
      } else {
        print("Failed to download PDF");
      }
    } catch (e) {
      print("Error downloading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Viewer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              if (localFilePath.isNotEmpty) {
                await OpenFilex.open(
                    localFilePath); // Open the file with a download option
              }
            },
          ),
        ],
      ),
      body: localFilePath.isNotEmpty
          ? PDFView(
              filePath: localFilePath,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
