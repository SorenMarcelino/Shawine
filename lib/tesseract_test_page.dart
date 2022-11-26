import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'preview_page.dart';

class TesseractTestPage extends StatefulWidget {
  const TesseractTestPage(
      {super.key, required this.title, required this.extractedText});

  final String title;
  final String extractedText;

  @override
  State<TesseractTestPage> createState() => _TesseractTestPageState();
}

class _TesseractTestPageState extends State<TesseractTestPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget.extractedText),
            ],
          ),
        ),
      ),
    );
  }
}
