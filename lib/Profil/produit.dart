import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Util/style.dart';
import '../Profil/insert_data.dart';

class Produit extends StatefulWidget {
  const Produit({Key? key}) : super(key: key);

  @override
  State<Produit> createState() => _ProduitState();
}

class _ProduitState extends State<Produit> {
  List userdata = [];
  String? mail;
  bool isLoading = false; // Ajout du booléen pour gérer l'état de chargement

  Future<void> delrecord(String id) async {

        try {
      var url = "$Adress_IP/profil/delete.php";
      var result = await http.post(Uri.parse(url), body: {"id": id});
      var response = jsonDecode(result.body);
      if (response["Success"] == "True") {
        print("record deleted");
        getrecord();
      } else {
        print("Erreur de suppression");
        getrecord();
      }
    } catch (e) {
      print(e);
    }
    // Afficher une boîte de dialogue de confirmation
  
  }

  Future<void> getrecord() async {
    setState(() {
      isLoading = true; // Activez le chargement avant d'effectuer la requête
    });
    var url = "https://royalrisingplus.com/aces/aces.php";
    try {
      var response = await http.get(Uri.parse(url));
      List reversedData = jsonDecode(response.body).reversed.toList();
      setState(() {
        userdata = reversedData;
        isLoading = false; // Désactivez le chargement après avoir reçu les données
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false; // Désactivez le chargement en cas d'erreur
      });
    }
  }

  @override
  void initState() {
    getrecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
centerTitle: true,
        backgroundColor: CouleurPrincipale,
        title: Text(widget.toString()),
      ),
      body: isLoading // Vérifiez si isLoading est vrai pour afficher le loader
          ? Center(
              child: CircularProgressIndicator(), // Ajout du loader
            )
          : ListView.builder(
              itemCount: userdata.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          'https://royalrisingplus.com/aces/profil/${userdata[index]["image1"]}'),
                    ),
                    title: Text(userdata[index]["nom"]),
                    subtitle: Text(userdata[index]["detail"]),
                    trailing: IconButton(
                      onPressed: () {
                        delrecord(userdata[index]["id"]);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Inset_Data(),
            ),
          );
        },
        child: const Icon(Icons.add_business_outlined),
      ),
    );
  }
}
