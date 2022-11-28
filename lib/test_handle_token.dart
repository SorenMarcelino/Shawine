import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class HandleToken extends StatefulWidget {
  const HandleToken({super.key, required this.title, required this.token});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String token;

  @override
  State<HandleToken> createState() => _HandleToken();
}

class _HandleToken extends State<HandleToken> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.token),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
                future: SessionManager().get('nom'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Ca marche po');
                  } else if (snapshot.hasData) {

                    return Text(snapshot.data!);
                  } else {
                    return const Text('Pas de données vin.');
                  }
                }),
          ],
        ),
      ),
    );
  }
}
