import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> makePdf() async {
  final pdf = pw.Document();
  final imageLogo = pw.MemoryImage((await rootBundle.load(
    'assets/bigme.JPG',
  ))
      .buffer
      .asUint8List());

  final imageWatermark = pw.MemoryImage((await rootBundle.load(
    'assets/medicard_watermark.png',
  ))
      .buffer
      .asUint8List());

  pdf.addPage(pw.Page(build: (context) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: pw.Column(
        children: [
          pw.Row(
            children: [
              pw.Image(imageLogo, height: 90.0, width: 120.0),
              pw.SizedBox(width: 5.0),
              pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('MediCard Davao Clinic',
                      style: pw.TextStyle(
                          fontSize: 20.0, fontWeight: pw.FontWeight.bold)),
                  pw.Container(
                    width: double.infinity - 25.0,
                    child: pw.Text(
                        'Unit 1, 8B-8C, LSA Center, J.P. Laurel Avenue, Bajada, Davao City,\nDavao City, Philippines\ninquiry@medicardphils.com, +639989631306',
                        softWrap: true,
                        maxLines: 3,
                        style: pw.TextStyle(fontSize: 10.0)),
                  ),
                ],
              ),
            ],
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Name: ', style: pw.Theme.of(context).header4),
              pw.Text('Date: ', style: pw.Theme.of(context).header4)
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Age:', style: pw.Theme.of(context).header5),
              pw.Text('Sex: ', style: pw.Theme.of(context).header5)
            ],
          ),
          pw.Text('Company: AMCOR SPECIALTY CARTONS RIZAL CORPS',
              style: pw.Theme.of(context).header5),
          pw.Text('Company: AMCOR SPECIALTY CARTONS RIZAL CORPS',
              style: pw.Theme.of(context).header5),
          pw.Divider(),
          pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 10.0),
              child: pw.Text(
                  '1. 0.9 SODIUM CHLORIDE bb nn, #m m m\n(,, ,)\nSig: m m m as needed\nNotes: ,,',
                  style: pw.Theme.of(context).header5)),
          pw.SizedBox(
            height: 80.0,
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Next Visit: ________________________',
                  style: pw.Theme.of(context).header5),
              pw.Text('MEEKO DIASANTA', style: pw.Theme.of(context).header5),
            ],
          ),
          pw.Text('License No: ________________________',
              style: pw.Theme.of(context).header5),
          pw.Text('PTR No: ________________________',
              style: pw.Theme.of(context).header5),
          pw.Text(
              'This is a computer-generated medical record and has been electronically validated. If issued without any alteration, no signature is required.',
              style: pw.Theme.of(context).header5),
        ],
      ),
    );
  }));
  return pdf.save();
}



/*Scaffold(
        appBar: kAppBar(context, 'My Cure PDF Viewer'),
        body: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/ic_logo_vertical.png',
                      height: constraints.maxHeight * 0.1,
                      width: constraints.maxWidth * 0.2,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('MediCard Davao Clinic',
                            style: Theme.of(context).textTheme.headline6),
                        Text(
                            'Unit 1, 8B-8C, LSA Center, J.P. Laurel Avenue, Bajada, Davao City,\nDavao City, Philippines\ninquiry@medicardphils.com, +639989631306',
                            style: Theme.of(context).textTheme.bodyText2),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Name: $name',
                        style: Theme.of(context).textTheme.bodyText2),
                    Text('Date: $date',
                        style: Theme.of(context).textTheme.bodyText2)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Age: $age',
                        style: Theme.of(context).textTheme.bodyText2),
                    Text('Sex: $sex',
                        style: Theme.of(context).textTheme.bodyText2)
                  ],
                ),
                Text('Company: AMCOR SPECIALTY CARTONS RIZAL CORPS',
                    style: Theme.of(context).textTheme.bodyText2),
                Text('Company: AMCOR SPECIALTY CARTONS RIZAL CORPS',
                    style: Theme.of(context).textTheme.bodyText2),
                Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 10.0),
                  child: Text(
                      '1. 0.9 SODIUM CHLORIDE bb nn, #m m m\n(,, ,)\nSig: m m m as needed\nNotes: ,,',
                      style: Theme.of(context).textTheme.headline6),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Next Visit: ________________________',
                        style: Theme.of(context).textTheme.bodyText2),
                    Text('MEEKO DIASANTA',
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
                Text('License No: ________________________',
                    style: Theme.of(context).textTheme.bodyText2),
                Text('PTR No: ________________________',
                    style: Theme.of(context).textTheme.bodyText2),
                Text(
                    'This is a computer-generated medical record and has been electronically validated. If issued without any alteration, no signature is required.',
                    style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
          );
        }))*/