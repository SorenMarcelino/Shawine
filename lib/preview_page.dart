import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'tesseract_test_page.dart';

import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {

  bool _scanning = false;
  String _extractText = '';
  File _image = File('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Page')),
      body: Center(
        child: Column(
          children: <Widget>[
            Column(mainAxisSize: MainAxisSize.min, children: [
              Image.file(File(widget.picture.path), fit: BoxFit.cover, width: 250),
              const SizedBox(height: 24),
              Text(widget.picture.path)
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Reprendre la photo'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: const Text('Continuer avec celle là'),
                  onPressed: () async {
                    setState(() {
                      _scanning = true;
                    });
                    _image = await File(widget.picture.path);
                    _extractText = await FlutterTesseractOcr.extractText(_image.path, language: 'fra+eng', args: {
                      "psm": "4",
                      "preserve_interword_spaces": "1",
                      //"textord_space_size_is_variable": ""
                    });
                    setState(() {
                      _scanning = false;
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TesseractTestPage(title: "Inscription", extractedText: _extractText)));
                  },
                ),
              ],
            ),
            Text(_extractText),
          ],
        ),
      ),
    );
  }
}
