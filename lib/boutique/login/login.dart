import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kactu/Util/style.dart';
import 'package:kactu/boutique/Profil/UserPost.dart';
import 'package:kactu/boutique/login/authServices.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  bool _inLoginProcess = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    // Vérifier si l'utilisateur est déjà connecté (implémentation dépendante de votre système d'authentification)
    bool isLoggedIn = await AuthService().isLoggedIn(); // Exemple hypothétique

    if (isLoggedIn) {
      // Si l'utilisateur est déjà connecté, naviguez vers la page de profil
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const UserPost(),
        ),
      );
    } else {
      // Sinon, l'utilisateur doit se connecter
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60),
              ),
              Image.network(
                height: MediaQuery.of(context).size.height * 0.4,
                'https://www.fpmarkets.com/assets/images/blogs/shutterstock_2014628297.webp',
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '   Bienvenue sur KACTU Market ',
                      style: TitreStyle,
                    ),


                    const Icon(Icons.shopping_cart_outlined)
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "L'espace dédié aux vendeurs ",
                    textAlign: TextAlign.center,
                    style: DescStyle,
                  ),
                ),
              ),
              _inLoginProcess
                  ? Center(
                      child: CircularProgressIndicator(
                        color: CouleurPrincipale,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: GestureDetector(
                        onTap: () => signIn(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                CouleurPrincipale, // Couleur de fond ajoutée ici
                            borderRadius: BorderRadius.circular(4),
                          ),
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.050,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/g.png', // Remplacez par votre propre icône de Google
                                height: 24.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Créer une boutique',
                                  style: GoogleFonts.abel(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn(BuildContext context) async {
    setState(() {
      _inLoginProcess = true;
    });

    await AuthService().signInWithGoogle();

    setState(() {
      _inLoginProcess = false;
    });

    // Vérifier à nouveau l'état de connexion après la connexion
    await checkLoginStatus();
  }
}
