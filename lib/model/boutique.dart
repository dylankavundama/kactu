// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kactu/boutique/ProductDetailPage.dart';
import 'package:kactu/boutique/boutique_ui.dart';
import '../Util/style.dart';

class Boutique extends StatefulWidget {
  const Boutique({super.key});

  @override
  State<Boutique> createState() => _BoutiqueState();
}

class _BoutiqueState extends State<Boutique> {
  List<dynamic> post = [];
  bool _isLoading = false;

  fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    var url = "$Adress_IP/boutique.php";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List resultat = jsonDecode(response.body);
      resultat.sort((a, b) => b["id"].compareTo(a["id"]));
      setState(() {
        post = resultat;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Boutique'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: CouleurPrincipale,
              ),
            )
          : post.isEmpty
              ? Center(
                  child: Image.asset(
                    'assets/error.png', // Chemin de votre image
                    width: 200,
                    height: 200,
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items per row
                    crossAxisSpacing: 10.0, // Spacing between items in a row
                    mainAxisSpacing: 10.0, // Spacing between rows
                    childAspectRatio: 0.7, // Aspect ratio of each item
                  ),
                  itemCount: post.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ProductDetailPage(
                                  prix: post[index]['prix'],
                                  auteur: post[index]['auteur'],
                                  id: '',
                                  titre: post[index]['nom'],
                                  desc: post[index]['detail'],
                                  image1: post[index]['image1'],
                                  image2: post[index]['image2'],
                                  num: post[index]['num']);
                            }),
                          );
                        },
                        child: boutique_ui(
                          prix: post[index]['prix'],
                          titre: post[index]['nom'],
                          image1: post[index]['image1'],
                        ));
                  },
                ),
    );
  }
}
