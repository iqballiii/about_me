import 'dart:convert';
import 'dart:typed_data';
import 'package:about_me/pdf_export.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pdw;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<void> securePdf() async {
    PdfImage imageWatermark = PdfBitmap((await rootBundle.load(
      'assets/medicard_watermark.png',
    ))
        .buffer
        .asUint8List());
    PdfDocument document = PdfDocument(inputBytes: await makePdf());
    PdfPage page = document.pages[0];
    PdfGraphics graphics = page.graphics;
    graphics.setTransparency(0.3);
    graphics.drawImage(
        imageWatermark,
        Rect.fromLTWH(
            0.0, page.size.height * 0.2, page.size.width, page.size.height));
    graphics.restore();
    document.security.userPassword = '1';
    document.security.ownerPassword = 'owner@123';
    List<int> bytes = await document.save();
    document.dispose();
    print('The save file function is called');
    _launchPdf(bytes, 'secured.pdf');
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> _launchPdf(List<int> bytes, String fileName) async {
    Directory? directory = await getExternalStorageDirectory();
    String path = directory!.path;
    File file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    //saves the document.
    _savePDF(fileName, bytes);
    print('The save file function is called');

    OpenFile.open('$path/$fileName');
  }

  Future<void> restrictPermissions() async {
    //Load the existing PDF document.
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData('test_data.pdf'));
    //Create document security.
    PdfSecurity security = document.security;
    //Set the owner password for the document.
    security.ownerPassword = 'owner@123';
    //Set various permission.
    security.permissions.addAll(<PdfPermissionsFlags>[
      PdfPermissionsFlags.fullQualityPrint,
      PdfPermissionsFlags.print,
      PdfPermissionsFlags.fillFields,
      PdfPermissionsFlags.copyContent
    ]);
    //Save and dispose the document.
    List<int> bytes = await document.save();
    document.dispose();
    //Open the PDF file.
    _launchPdf(bytes, 'permissions.pdf');
  }

  Future<void> decryptPDF() async {
    //Load the PDF document with permission password.
    PdfDocument document = PdfDocument(
        inputBytes: await _readDocumentData('secured.pdf'),
        password: 'owner@123');
    //Get the document security.
    PdfSecurity security = document.security;
    //Set owner and user passwords are empty string.
    security.userPassword = '';
    security.ownerPassword = '';
    //Clear the security permissions.
    security.permissions.clear();
    //Save and dispose the document.
    List<int> bytes = await document.save();
    document.dispose();
    //Open the PDF file.
    _launchPdf(bytes, 'unsecured.pdf');
  }

  // void addWatermark() async {
  //   PdfDocument documents =
  //       PdfDocument(inputBytes: await _readDocumentData('test_data.pdf'));
  //   PdfPage page = documents.pages[0];
  //   //Get page size
  //   Size pageSize = page.getClientSize();
  //   //Set a standard font
  //   PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 40);
  //   //Measure the text
  //   Size size = font.measureString('Confidential');
  //   //Create PDF graphics for the page
  //   PdfGraphics graphics = page.graphics;
  //   //Calculate the center point.
  //   double x = pageSize.width / 2;
  //   double y = pageSize.height / 2;
  //   //Save the graphics state for the watermark text
  //   graphics.save();
  //   //Tranlate the transform with the center point.
  //   graphics.translateTransform(x, y);
  //   //Set transparency level for the text
  //   graphics.setTransparency(0.25);
  //   //Rotate the text to -40 Degree
  //   graphics.rotateTransform(-40);
  //   //Draw the watermark text to the desired position over the PDF page with red color
  //   graphics.drawString('Confidential', font,
  //       pen: PdfPen(PdfColor(255, 0, 0)),
  //       brush: PdfBrushes.red,
  //       bounds: Rect.fromLTWH(
  //           -size.width / 2, -size.height / 2, size.width, size.height));
  //   //Restore the graphics
  //   graphics.restore();
  //   //Save the document
  //   List<int> bytes = documents.save();
  // }

  void _savePDF(String fileName, List<int> bytes) async {
    final pdf = PdfDocument.fromBase64String(Base64Encoder().convert(bytes));
    // On Flutter, use the [path_provider](https://pub.dev/packages/path_provider) library:
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/$fileName");
    print('The save file function is called');
    // final file = File("example.pdf");
    try {
      await file.writeAsBytes(await pdf.save());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title:
                Text('About Me', style: TextStyle(fontWeight: FontWeight.w500)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 80.0,
                  backgroundImage: AssetImage('assets/bigme.JPG'),
                ),
                Card(
                  color: Colors.grey.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Flutter Developer')),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      color: Colors.red,
                      onPressed: () {
                        print('the yes button was pressed');
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    FlatButton(
                      color: Colors.blue,
                      onPressed: () {
                        print('the no button was pressed');
                      },
                      child: Text(
                        'NO',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: securePdf,
                        child: Text('Encrypt PDF'),
                      ),
                      // FlatButton(onPressed: securePdf, child: Text('Encrypt PDF')),
                      // FlatButton(
                      //     onPressed: restrictPermissions,
                      //     child: Text('Restrict Permissions')),
                      FlatButton(
                          onPressed: decryptPDF, child: Text('Decrypt PDF')),
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
