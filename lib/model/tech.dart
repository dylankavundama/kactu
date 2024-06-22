import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kactu/UI.dart';
import 'package:kactu/detailpage.dart';

import 'package:http/http.dart' as http;

import '../Util/style.dart';

class Tech_Page extends StatefulWidget {
  const Tech_Page({super.key});

  @override
  State<Tech_Page> createState() => _Tech_PageState();
}

class _Tech_PageState extends State<Tech_Page> {
  List<dynamic> post = [];
  bool _isLoading = false;

  fetchPosts() async {
    setState(() {
      _isLoading = true;
    });
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final cachedData = prefs.getString('entreprise_data');
    // if (cachedData != null) {
    //   setState(() {
    //     post = jsonDecode(cachedData);
    //     _isLoading = false;
    //   });
    //   return;
    // }
    var url = "$Adress_IP/tech.php";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List resultat = jsonDecode(response.body);
      resultat.sort((a, b) => b["id"].compareTo(a["id"]));
      setState(() {
        post = resultat;
        _isLoading = false;
      });
      // Cache the data
      // prefs.setString('entreprise_data', response.body);
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
    return _isLoading
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
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    post.length,
                    (index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return DetailPage(
                              date: post[index]['dateN'],
                              auteur: post[index]['auteur'],
                              id: '',
                              titre: post[index]['titre'],
                              source: post[index]['source'],
                              desc: post[index]['detail'],
                              image1: post[index]['image1'],
                              image2: post[index]['image2'],
                            );
                          }),
                        );
                      },
                      child: Widget_UI(
                        id: '',
                        date: post[index]['dateN'],
                        desc: post[index]['detail'],
                        titre: post[index]['titre'],
                        image: post[index]['image1'],
                      ),
                    ),
                  ),
                ),
              );
  }
}
