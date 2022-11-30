import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'test_handle_token.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});

  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController avatarController = TextEditingController();

  Future<http.Response> postUser(
      TextEditingController nom,
      TextEditingController prenom,
      TextEditingController email,
      TextEditingController password,
      TextEditingController avatar) async {
    var data = {
      'nom': nom.text,
      'prenom': prenom.text,
      'email': email.text,
      'password': password.text,
      'avatar': avatar.text
    };
    print("dataContentUser : $data"); // Debug
    // BEGIN -- Envoi de la requête au serveur //
    var response = await http.post(
      Uri.parse('http://192.168.1.154:5000/api/auth/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    // END -- Envoi de la requête au serveur //
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
                    'Créez un compte',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nomController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nom',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: prenomController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Prénom',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mot de passe',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  controller: avatarController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Photo de profil',
                  ),
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Inscription'),
                    onPressed: () {
                      postUser(nomController, prenomController, emailController,
                          passwordController, avatarController);
                    },
                  )),
              Row(
                children: <Widget>[
                  const Text('Vous avez déjà un compte ?'),
                  TextButton(
                    child: const Text(
                      'Connectez-vous',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
