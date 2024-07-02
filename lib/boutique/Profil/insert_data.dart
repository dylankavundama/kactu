import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kactu/Util/style.dart';
import 'package:kactu/boutique/Profil/UserPost.dart';

import 'dart:core';

class Inset_Data extends StatefulWidget {
  const Inset_Data({super.key});
  @override
  State<Inset_Data> createState() => _Inset_DataState();
}

class _Inset_DataState extends State<Inset_Data> {
  TextEditingController nom = TextEditingController();
  TextEditingController detail = TextEditingController();
  TextEditingController prix = TextEditingController();
  TextEditingController num = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  showToast({required String msg}) {
    return Fluttertoast.showToast(msg: msg);
  }

  Future<void> savadatas(Entreprise entreprise, String email) async {
    if (nom.text.isEmpty ||
        detail.text.isEmpty ||
        prix.text.isEmpty ||
        num.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous avez un champ vide'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    try {
      var url = "$Adress_IP/profil/add.php";
      Uri ulr = Uri.parse(url);
      var request = http.MultipartRequest('POST', ulr);
      request.fields['nom'] = nom.text;
      request.fields['detail'] = detail.text;
      request.fields['prix'] = prix.text;
      request.fields['num'] = num.text;
      request.fields['auteur'] = email; // Insert email here
      request.files.add(http.MultipartFile.fromBytes(
          'image1', File(_image!.path).readAsBytesSync(),
          filename: _image!.path));

      request.files.add(http.MultipartFile.fromBytes(
          'image2', File(_image2!.path).readAsBytesSync(),
          filename: _image2!.path));
      var res = await request.send();
      var response = await http.Response.fromStream(res);

      if (response.statusCode == 200) {
        showToast(msg: "Succès !");
      } else {
        showToast(msg: "Problème d'insertion !");
      }
    } catch (e) {
      showToast(msg: 'Erreur survenue');
    }
  }

  bool _isLoading = false;

  //location

//insert picture
  File? _image;
  File? _image2;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Erreur lors de la sélection de l\'image : $e');
    }
  }

  Future<void> _pickImage2(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image2 = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Erreur lors de la sélection de l\'image : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sreenh = MediaQuery.of(context).size.height;
    User? user = FirebaseAuth.instance.currentUser;
    final sreenw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CouleurPrincipale,
        title: Text(
          ' ${user?.displayName ?? "Non défini"}',
          style: const TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Image.network(
                        "https://cdni.iconscout.com/illustration/premium/thumb/woman-create-new-post-online-8621118-6842172.png"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Center(
                    child: Text(
                      "Ajouter un post",
                      style: TitreStyle,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: nom,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      hintText: "Jina",
                      labelText: "Nom du produit"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: detail,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      hintText: "Ma detaile",
                      labelText: "Description"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  maxLength: 9,
                  keyboardType: TextInputType.number,
                  controller: num,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.web),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      hintText: "Exemple :976736700",
                      labelText: "Numero"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: prix,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.web),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      hintText: "Bei",
                      labelText: "Prix"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "sélectionnée :",
                      style: TitreStyle,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            CouleurPrincipale, // Définir la couleur du bouton
                        // Autres propriétés de style du bouton peuvent être définies ici
                      ),
                      child: Text(
                        "la photo1",
                        style: TitreStyleWhite,
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                    const SizedBox(width: 4),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            CouleurPrincipale, // Définir la couleur du bouton
                        // Autres propriétés de style du bouton peuvent être définies ici
                      ),
                      child: Text(
                        "la photo2",
                        style: TitreStyleWhite,
                      ),
                      onPressed: () => _pickImage2(ImageSource.gallery),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(ImageSource.gallery),
                      child: SizedBox(
                        height: sreenh * 0.2,
                        width: sreenw * 0.45,
                        child: Center(
                          child: _image == null
                              ? Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors
                                          .black26, // Couleur de la bordure
                                      width: 1.0, // Épaisseur de la bordure
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text('Aucune image sélectionnée'),
                                  ),
                                )
                              : Image.file(_image!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 3),
                    GestureDetector(
                      onTap: () => _pickImage2(ImageSource.gallery),
                      child: SizedBox(
                        height: sreenh * 0.2,
                        width: sreenw * 0.45,
                        child: Center(
                          child: _image2 == null
                              ? Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors
                                          .black26, // Couleur de la bordure
                                      width: 1.0, // Épaisseur de la bordure
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text('Aucune image sélectionnée'),
                                  ),
                                )
                              : Image.file(_image2!),
                        ),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                  minWidth: double.maxFinite,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: CouleurPrincipale,
                  onPressed: () {
                    if (num.text.isEmpty) {
                      showToast(msg: "Y'a une case vide");
                    } else if (prix.text.isEmpty) {
                      showToast(msg: "ajouter le prix");
                    } else if (detail.text.isEmpty && num.text.isEmpty) {
                      showToast(msg: "Y'a une case vide");
                    } else {
                      setState(() {
                        _isLoading = true;
                      });
                      savadatas(
                        Entreprise(
                          nom: nom.text.trim(),
                          detail: detail.text.trim(),
                          prix: prix.text.trim(),
                          num: num.text.trim(),
                        ),
                        FirebaseAuth.instance.currentUser?.displayName ?? '',
                      ).then((value) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const UserPost()));
                      }).whenComplete(() {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Ajouter",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Entreprise {
  int? code;
  String? nom;
  String? detail;
  String? prix;
  String? num;

  Entreprise({
    this.code,
    this.nom,
    this.detail,
    this.prix,
    this.num,
  });

  factory Entreprise.fromJson(Map<String, dynamic> json) =>
      _$EntrepriseFromJson(json);
  Map<String, dynamic> toJson() => _$EntrepriseToJson(this);
}

Entreprise _$EntrepriseFromJson(Map<String, dynamic> json) {
  return Entreprise(
    code: json['id'] as int,
    nom: json['nom'] as String,
    detail: json['detail'] as String,
    prix: json['prix'] as String,
    num: json['num'] as String,
  );
}

Map<String, dynamic> _$EntrepriseToJson(Entreprise instance) =>
    <String, dynamic>{
      'nom': instance.nom,
      'detail': instance.detail,
      'prix': instance.prix,
      'num': instance.num,
    };
