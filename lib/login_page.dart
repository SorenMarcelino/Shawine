import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'test_handle_token.dart';
import 'signUp_page.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var sessionManager = SessionManager();

  Future<http.Response> postUser(
      TextEditingController name, TextEditingController password) async {
    var data = {'email': name.text, 'password': password.text};
    // BEGIN -- Envoi de la reqête au serveur //
    var response = await http.post(
      Uri.parse('http://192.168.1.154:5000/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    print(response.body);

    Map<String, dynamic> res = jsonDecode(response.body);
    print('Result : ' + res['_id']['\$oid']);

    await sessionManager.set('id', res['_id']['\$oid']);
    await sessionManager.set('nom', res['nom']);
    await sessionManager.set('prenom', res['prenom']);
    await sessionManager.set('email', res['email']);
    await sessionManager.set('avatar', res['avatar']);
    await sessionManager.set('token', res['token']);

    // END -- Envoi de la reqête au serveur //bug
    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
    return response;
  }

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
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Connectez-vous',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
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
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Connexion'),
                    onPressed: () {
                      postUser(nameController, passwordController);
                    },
                  )),
              Column(
                children: <Widget>[
                  const Text('Vous n\'avez pas encore de compte'),
                  TextButton(
                    child: const Text(
                      'Créez un compte',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SignUpPage(title: "Inscription")));
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
