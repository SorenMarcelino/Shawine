import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'test_handle_token.dart';
import 'signUp_page.dart';
import 'Vins.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Commentaires.dart';
import 'User.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class DetailVin extends StatefulWidget {
  const DetailVin(
      {super.key,
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

  Future<List<Commentaires>> commentairesFuture = getCommentaires();

  static Future<List<Commentaires>> getCommentaires() async {
    var response = await http.get(Uri.parse(
        'http://192.168.1.154:5000/api/vin/AOC BOURGOGNE HAUTES-CÔTES DE BEAUNE/commentaires'));
    var body = json.decode(response.body);
    print(body);
    return body.map<Commentaires>(Commentaires.fromJson).toList();
  }

  Future<String> getUser(String userId) async {
    var response =
        await http.get(Uri.parse('http://192.168.1.154:5000/api/user/$userId'));
    var body = json.decode(response.body);

    Map<String, dynamic> res = jsonDecode(response.body);
    print('Result : ' + res['nom']);

    return res['prenom'] + ' ' + res['nom'];
  }

  Future<void> _successDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Suppression réussie'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Votre commentaire à bien été supprimé.'),
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

  Future<void> _failDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Suppression échouée'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Le commentaire n\'a pas été supprimé.'),
                Text('Vous n\'êtes peut-être pas le propriétaire de ce commentaire.'),
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

  Widget buildCommentaires(List<Commentaires> commentaires) => ListView.builder(
        shrinkWrap: true,
        itemCount: commentaires.length,
        itemBuilder: (context, index) {
          final commentaire = commentaires[index];
          var userNom = getUser(commentaire.added_by);
          return FutureBuilder<String>(
              future: userNom,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("ERROR: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;

                  print('userNom : $user');
                  return Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          /*leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(user.avatar),
                      ),*/
                          title: Text(user),
                          subtitle: Text(commentaire.commentaire),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              tooltip: 'Modifier',
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              tooltip: 'Supprimer',
                              onPressed: () {
                                deleteCommentaire(commentaire.commentaire_id);
                                //_successDelete();
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text('Pas de données vin.');
                }
              });
        },
      );

  TextEditingController commentaireController = TextEditingController();

  Future<http.Response> postCommentaire(
      TextEditingController commentaire) async {
    var data = {'commentaire': commentaire.text};
    dynamic user_token = await SessionManager().get("token");
    var response = await http.post(
      Uri.parse('http://192.168.1.154:5000/api/vin/${widget.id}/commentaires'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $user_token',
      },
      body: jsonEncode(data),
    );
    print(response.body);

    return response;
  }

  Future<http.Response> deleteCommentaire(String commentaire_id) async {
    dynamic user_token = await SessionManager().get("token");
    var response = await http.delete(
      Uri.parse(
          'http://192.168.1.154:5000/api/vin/${widget.id}/commentaire/${commentaire_id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $user_token',
      },
      //body: jsonEncode(data),
    );
    print(response.body);
    if (response.statusCode == 200) {
      _successDelete();
    }
    else{
      _failDelete();
    }

    return response;
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
                child: Text(
                  widget.nom,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
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
              Container(
                child: Text(
                  "Commentaires",
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  maxLines: 2, //or null
                  controller: commentaireController,
                  decoration: InputDecoration.collapsed(
                    hintText: "Ecrivez votre commentaire ici",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('Envoyer le commentaire'),
                onPressed: () {
                  postCommentaire(commentaireController);
                },
              ),
              FutureBuilder<List<Commentaires>>(
                  future: commentairesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("ERROR: ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      final commentaires = snapshot.data!;

                      return buildCommentaires(commentaires);
                    } else {
                      return const Text('Pas de données vin.');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
