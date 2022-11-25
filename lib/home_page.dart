import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'camera_page.dart';
import 'login_page.dart';
import 'Vins.dart';
import 'detail_vin_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Vins>> vinsFuture = getVins();

  static Future<List<Vins>> getVins() async {
    var response =
        await http.get(Uri.parse('http://192.168.1.154:5000/api/vins'));
    var body = json.decode(response.body);
    print("dataContentVins : $body");
    return body.map<Vins>(Vins.fromJson).toList();
  }

  Widget buildVins(List<Vins> vins) => ListView.builder(
        shrinkWrap: true,
        itemCount: vins.length,
        itemBuilder: (context, index) {
          final vin = vins[index];
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailVin(nom: vin.nom, descriptif: vin.descriptif, couleur: vin.couleur, embouteillage: vin.embouteillage, cepage: vin.cepage, chateau_domaine_propriete_clos: vin.chateau_domaine_propriete_clos, annee: vin.annee, prix: vin.prix, image_bouteille: vin.image_bouteille, url_producteur: vin.url_producteur))); // To adapt
              },
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(vin.image_bouteille),
              ),
              title: Text(vin.nom),
              subtitle: Text(vin.couleur),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SingleChildScrollView(
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Connectez vous pour noter les vin et poster des commentaires',
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(title: "Login")));
                },
                child: const Text(
                  'Se connecter/S\'inscrire ',
                ),
              ),
              FutureBuilder<List<Vins>>(
                  future: vinsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Ca marche po');
                    } else if (snapshot.hasData) {
                      final vins = snapshot.data!;

                      return buildVins(vins);
                    } else {
                      return const Text('Pas de données vin.');
                    }
                  })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await availableCameras().then((value) => Navigator.push(context,
              MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
        },
        //tooltip: 'Increment',
        child: const Icon(Icons.camera_alt_rounded),
      ),
    );
  }
}
