import 'dart:typed_data';

import 'package:flutter/material.dart';

//TODO: Import the libraries
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Printer Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pageFormat = PdfPageFormat(113.38582677165354, 141.73228346456693,
      marginAll: 4.251968503937007);
  Printer selectPrinter;

  //TODO: Make your document
  Future<Uint8List> getDoc() async {
    //TODO: Load font from assets
    var ttf = await fontFromAssetBundle('fonts/TaipeiSansTCBeta-Regular.ttf');
    final textStyle = pw.TextStyle(font: ttf, fontSize: 13);

    //TODO: Load image from assets
    // final image = await imageFromAssetBundle('images/dog.png');

    //TODO: Load pdf from assets
    // final pdfData = await rootBundle.load('images/sample.pdf');

    //TODO: Edit your doc
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: pageFormat,
        orientation: pw.PageOrientation.landscape,
        build: (pw.Context context) {
          return pw.Center(
              child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.max,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                pw.Text('【30】', style: textStyle),
                pw.Text('王小明/A999999999', style: textStyle),
                pw.Text('0800808(年齡：88)', style: textStyle),
                pw.Text('流感、北肺、新冠', style: textStyle),
                // pw.Image(image, width: 30),
              ]));
        }));
    return doc.save();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.print),
              //TODO: Add print onPressed
              onPressed: () async {
                //TODO: print with preview
                // await Printing.layoutPdf(onLayout: (format) {
                //   return getDoc();
                // });
                //TODO: print without preview
                if (selectPrinter == null) {
                  selectPrinter = await Printing.pickPrinter(context: context);
                }
                await Printing.directPrintPdf(
                    format: pageFormat,
                    printer: selectPrinter,
                    onLayout: (format) => getDoc());
              })
        ],
      ),
      body: Center(
        child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            //TODO: Preview Pdf
            child: PdfPreview(build: (format) => getDoc())),
      ),
    );
  }
}
