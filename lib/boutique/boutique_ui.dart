// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Util/style.dart';

// ignore: must_be_immutable, camel_case_types
class boutique_ui extends StatelessWidget {
  boutique_ui({
    super.key,
    required this.titre,
    required this.prix,
    required this.image1,
  });

  String titre;
  String prix;
  String image1;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(
            "$Adress_IP/profil/$image1",
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Text(
                  'Erreur de chargement de l\'image',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: CouleurPrincipale),
                ),
              );
            },
          ),
          const Divider(
            color: Colors.black38,
          ),
          Text(titre,
              maxLines: 1,
              style: GoogleFonts.abel(fontSize: 19, color: Colors.black)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Prix:",
                  style:
                      GoogleFonts.aBeeZee(fontSize: 15, color: Colors.black54),
                  textAlign: TextAlign.start,
                ),
              ),
              Text(
                "$prix\$",
                style:
                    GoogleFonts.aBeeZee(fontSize: 18, color: CouleurPrincipale),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
