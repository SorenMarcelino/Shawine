import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class EditVinPage extends StatefulWidget {
  const EditVinPage(
      {super.key,
      required this.title,
      required this.id,
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

  final String title;
  final String id;
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
  State<EditVinPage> createState() => _EditVinPageState();
}

class _EditVinPageState extends State<EditVinPage> {
  late TextEditingController editNomController = TextEditingController(text: widget.nom);
  late TextEditingController editDescriptifController = TextEditingController(text: widget.descriptif);
  late TextEditingController editCouleurController = TextEditingController(text: widget.couleur);
  late TextEditingController editEmbouteillageController = TextEditingController(text: widget.embouteillage);
  late TextEditingController editCepageController = TextEditingController(text: widget.cepage);
  late TextEditingController editChateau_domaine_propriete_closController =
      TextEditingController(text: widget.chateau_domaine_propriete_clos);
  late TextEditingController editAnneeController = TextEditingController(text: widget.annee);
  late TextEditingController editPrixController = TextEditingController(text: widget.prix);
  late TextEditingController editImage_bouteilleController = TextEditingController(text: widget.image_bouteille);
  late TextEditingController editUrl_producteurController = TextEditingController(text: widget.url_producteur);

  Future<http.Response> editVin(
      TextEditingController nom,
      TextEditingController descriptif,
      TextEditingController couleur,
      TextEditingController embouteillage,
      TextEditingController cepage,
      TextEditingController chateau_domaine_propriete_clos,
      TextEditingController annee,
      TextEditingController prix,
      TextEditingController image_bouteille,
      TextEditingController url_producteur) async {
    var data = {
      'nom': nom.text,
      'descriptif': descriptif.text,
      'couleur': couleur.text,
      'embouteillage': embouteillage.text,
      'cepage': cepage.text,
      'chateau_domaine_propriete_clos': chateau_domaine_propriete_clos.text,
      'annee': annee.text,
      'prix': prix.text,
      'image_bouteille': image_bouteille.text,
      'url_producteur': url_producteur.text
    };
    dynamic user_token = await SessionManager().get("token");
    print("dataContentUser : $data"); // Debug
    // BEGIN -- Envoi de la requête au serveur //
    var response = await http.put(
      Uri.parse('http://192.168.1.154:5000/api/vin/${widget.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $user_token',
      },
      body: jsonEncode(data),
    );
    // END -- Envoi de la requête au serveur //
    print('Body: ${response.statusCode}'); // Debug
    print('Body: ${response.body}'); // Debug
    if (response.statusCode == 200) {
      _successPost();
    } else {
      _failPost();
    }
    return response;
  }

  Future<void> _successPost() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vin modifié'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Le vin à bien été modifié.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _failPost() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Vin non modifié'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Le vin n\'a pas été modifié.'),
                Text('Vous n\'avez pas le droit de modifier un vin.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Modifier un vin de la collection',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: editNomController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nom',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: editDescriptifController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Descriptif',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: editCouleurController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'couleur',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: editEmbouteillageController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Embouteillage',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: editCepageController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Cepage',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: editChateau_domaine_propriete_closController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Chateau / Domaine / Propriété / Clos',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: editAnneeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Année',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: editPrixController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Prix',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: editImage_bouteilleController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'image_bouteille',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: editUrl_producteurController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'url_producteur',
                  ),
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Modifier'),
                    onPressed: () {
                      editVin(
                          editNomController,
                          editDescriptifController,
                          editCouleurController,
                          editEmbouteillageController,
                          editCepageController,
                          editChateau_domaine_propriete_closController,
                          editAnneeController,
                          editPrixController,
                          editImage_bouteilleController,
                          editUrl_producteurController);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
