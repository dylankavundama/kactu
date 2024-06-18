import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ibapp/HomePage.dart';
import 'package:ibapp/UI.dart';
import 'package:ibapp/detailpage.dart';

import 'package:http/http.dart' as http;

import '../Util/style.dart';

class Actualite_Page extends StatefulWidget {
  const Actualite_Page({super.key});

  @override
  State<Actualite_Page> createState() => _Actualite_PageState();
}

class _Actualite_PageState extends State<Actualite_Page> {
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
    var url = "$Adress_IP/actualite.php";
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
        final List<String> _images = [
    'https://images.pexels.com/photos/10811920/pexels-photo-10811920.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
    'https://images.pexels.com/photos/23440189/pexels-photo-23440189/free-photo-of-loneliness.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/5641802/pexels-photo-5641802.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
    'https://images.pexels.com/photos/23440189/pexels-photo-23440189/free-photo-of-loneliness.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ];
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
                  children: [
const NewWidget(images:  [
    'https://images.pexels.com/photos/10811920/pexels-photo-10811920.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
    'https://images.pexels.com/photos/23440189/pexels-photo-23440189/free-photo-of-loneliness.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/5641802/pexels-photo-5641802.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load',
    'https://images.pexels.com/photos/23440189/pexels-photo-23440189/free-photo-of-loneliness.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ]),
                    ...List.generate(
                    post.length,
                    (index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return DetailPage(
                              date: post[index]['dateN'],
                              auteur: post[index]['auteur'],
                               id: post[index]['id'],
                              titre: post[index]['titre'],
                              desc: post[index]['detail'],
                              image1: post[index]['image1'],
                              image2: post[index]['image2'],
                            );
                          }),
                        );
                      },
                      child: Widget_UI(
                          id: post[index]['id'],
                        date: post[index]['dateN'],
                        desc: post[index]['detail'],
                        titre: post[index]['titre'],
                        image: post[index]['image1'],
                      ),
                    ),
                  ),
                  ]
                ),
              );
  }
}
