import 'package:admin_ib/Profil/UserPost.dart';
import 'package:admin_ib/Util/style.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 80),
              ),
              Image.asset(
                height: MediaQuery.of(context).size.height * 0.4,
                'assets/lg.png',
              ),
              Center(
                child: Text(
                  '    Réserver à l’Administrateur  ',
                  style: TitreStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: Text(
                    "Assurez-vous d’avoir tous les droit",
                    style: DescStyle,
                  ),
                ),
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    labelText: 'Username', labelStyle: DescStyle),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password', labelStyle: DescStyle),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Check the credentials and navigate to the next screen
                  final username = usernameController.text;
                  final password = passwordController.text;

                  if (username == 'admin' && password == 'kactu') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserPost(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login failed. Check your credentials.'),
                      ),
                    );
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
