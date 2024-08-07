import 'dart:convert';
import 'dart:io';
import 'package:admin_ib/Util/style.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:admin_ib/Profil/UserPost.dart';
import 'dart:core';

class Inset_Data extends StatefulWidget {
  const Inset_Data({super.key});
  @override
  State<Inset_Data> createState() => _Inset_DataState();
}

class _Inset_DataState extends State<Inset_Data> {
  TextEditingController nom = TextEditingController();
  TextEditingController detail = TextEditingController();
  TextEditingController source = TextEditingController();
  TextEditingController dateN = TextEditingController();

  @override
  void initState() {
    super.initState();

    getrecord();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late String idenseu;
  // ignore: prefer_typing_uninitialized_variables
  var selectens;

  showToast({required String msg}) {
    return Fluttertoast.showToast(msg: msg);
  }

  List dataens = [];
  Future<void> getrecord() async {
    var url = "$Adress_IP/categorie.php";
    try {
      var response = await http.get(Uri.parse(url));
      setState(() {
        dataens = jsonDecode(response.body);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> savadatas(Entreprise entreprise) async {
    if (nom.text.isEmpty ||
        detail.text.isEmpty ||
        source.text.isEmpty ||
        dateN.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous avez un champ vide'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    try {
      var url = "$Adress_IP/profil/ajouter.php";
      Uri ulr = Uri.parse(url);
      var request = http.MultipartRequest('POST', ulr);

      request.fields['titre'] = nom.text;
      request.fields['cat'] = idenseu;
      request.fields['source'] = source.text;
      request.fields['detail'] = detail.text;
      request.fields['dateN'] = dateN.text;
 
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
    // User? user = FirebaseAuth.instance.currentUser;
    final sreenw = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CouleurPrincipale,
        // title: Text(
        //   ' ${user?.displayName ?? "Non défini"}',
        //   style: TextStyle(fontSize: 15),
        // ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Stack(
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(LineIcons.list),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                        readOnly: true,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: DropdownButton(
                          hint: const Text(
                              "-------------Sélectionner une catégorie-----------"),
                          items: dataens.map((list) {
                            return DropdownMenuItem(
                              value: list["id"],
                              child: Text(list["nom"]),
                            );
                          }).toList(),
                          value: selectens,
                          onChanged: (value) {
                            selectens = value;
                            idenseu = selectens;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
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
                      hintText: "Titre",
                      labelText: "Titre du post"),
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
                      hintText: "Detail",
                      labelText: "Description"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: source,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.web),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      hintText: "Source ou lien",
                      labelText: "source du post"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  controller: dateN,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: const InputDecoration(
                    hintText: 'Selectionner la  Date',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
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
                      child: Container(
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
                    if (idenseu.isEmpty) {
                      showToast(msg: "y'a une case vide");
                    } else if (source.text.isEmpty) {
                      showToast(msg: "Y'a une case vide");
                    } else if (dateN.text.isEmpty) {
                      showToast(msg: "Y'a une case vide");
                    } else if (detail.text.isEmpty &&
                        idenseu.isEmpty &&
                        source.text.isEmpty) {
                      showToast(msg: "Y'a une case vide");
                    } else {
                      setState(() {
                        _isLoading = true;
                      });
                      savadatas(
                        Entreprise(
                          titre: idenseu.trim(),
                          detail: detail.text.trim(),
                          source: source.text.trim(),
                          dateN: source.text.trim(),
                        ),
             
                      ).then((value) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const UserPost(),
                          ),
                        );
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dateN.text = picked.toString().substring(0, 10);
      });
    }
  }
}

class Entreprise {
  int? code;
  String? titre;
  String? detail;
  String? source;
  String? dateN;

  Entreprise({
    this.code,
    this.titre,
    this.detail,
    this.source,
    this.dateN,
  });

  factory Entreprise.fromJson(Map<String, dynamic> json) =>
      _$EntrepriseFromJson(json);
  Map<String, dynamic> toJson() => _$EntrepriseToJson(this);
}

Entreprise _$EntrepriseFromJson(Map<String, dynamic> json) {
  return Entreprise(
      code: json['id'] as int,
      titre: json['titre'] as String,
      source: json['source'] as String,
      dateN: json['dateN'] as String,
      detail: json['detail'] as String);
}

Map<String, dynamic> _$EntrepriseToJson(Entreprise instance) =>
    <String, dynamic>{
      'titre': instance.titre,
      'detail': instance.detail,
      'source': instance.source,
      'dateN': instance.dateN,
    };
