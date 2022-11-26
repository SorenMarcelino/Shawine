import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'test_handle_token.dart';
import 'signUp_page.dart';
import 'Vins.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailVin extends StatefulWidget {
  const DetailVin(
      {super.key,
      required this.nom,
      required this.descriptif,
      required this.couleur,
      required this.embouteillage,
      required this.cepage,
      required this.chateau_domaine_propriete_clos,
      required this.annee,
      required this.prix,
      required this.image_bouteille,
      required this.url_producteur});

  final String nom;
  final String descriptif;
  final String couleur;
  final String embouteillage;
  final String cepage;
  final String chateau_domaine_propriete_clos;
  final String annee;
  final String prix;
  final String image_bouteille;
  final String url_producteur;

  @override
  State<DetailVin> createState() => _DetailVinState();
}

class _DetailVinState extends State<DetailVin> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<http.Response> postUser(
      TextEditingController name, TextEditingController password) async {
    var data = {'email': name.text, 'password': password.text};
    print("dataContentUser : $data"); // Debug
    // BEGIN -- Envoi de la reqête au serveur //
    var response = await http.post(
      Uri.parse('http://192.168.1.154:5000/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    // END -- Envoi de la reqête au serveur //
    print('Body: ${response.statusCode}'); // Debug
    print('Body: ${response.body}'); // Debug
    if (response.statusCode == 200) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HandleToken(title: "HandleToken", token: response.body)));
    }
    return response;
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nom),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Image.network(widget.image_bouteille),
              ),
              Container(
                child: Text(widget.nom, style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
              ),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: Text('Couleur'),
                  subtitle: Text(widget.couleur),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Descriptif'),
                  subtitle: Text(widget.descriptif),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: Text('Cepage'),
                  subtitle: Text(widget.cepage),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: Text('Chateau/Domaine/Propriété/Clos'),
                  subtitle: Text(widget.chateau_domaine_propriete_clos),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: () {},
                  title: Text('Année'),
                  subtitle: Text(widget.annee),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Prix'),
                  subtitle: Text(widget.prix),
                ),
              ),
              ElevatedButton(
                child: const Text('Voir le site du producteur'),
                onPressed: () {
                  _launchURL(widget.url_producteur);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
