import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'tesseract_test_page.dart';

import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Vins.dart';
import 'detail_vin_page.dart';

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

  Future<http.Response> getVin(String _extractText) async {
    var url = 'http://192.168.1.154:5000/api/vin/$_extractText';
    var response = await http.get(Uri.parse(url.trim()));
    final Map<String, dynamic> data = json.decode(response.body);
    print("dataContentVin : $data");
    print(data['nom']);
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailVin(
                  id: data['_id']['\$oid'],
                  nom: data['nom'],
                  descriptif: data['descriptif'],
                  couleur: data['couleur'],
                  embouteillage: data['embouteillage'],
                  cepage: data['cepage'],
                  chateau_domaine_propriete_clos:
                  data['chateau_domaine_propriete_clos'],
                  annee: data['annee'],
                  prix: data['prix'],
                  image_bouteille: data['image_bouteille'],
                  url_producteur: data['url_producteur'])
          ),
      ); // To adapt
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Page')),
      body: Center(
        child: Column(
          children: <Widget>[
            Column(mainAxisSize: MainAxisSize.min, children: [
              Image.file(File(widget.picture.path),
                  fit: BoxFit.cover, width: 250),
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
                    _extractText = await FlutterTesseractOcr.extractText(
                        _image.path,
                        language: 'fra+eng',
                        args: {"psm": "4", "preserve_interword_spaces": "1"});
                    setState(() {
                      _scanning = false;
                    });
                    getVin(_extractText);
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
