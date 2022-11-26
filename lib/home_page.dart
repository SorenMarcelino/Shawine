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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
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
