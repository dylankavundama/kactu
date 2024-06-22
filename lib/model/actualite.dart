import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kactu/HomePage.dart';
import 'package:kactu/UI.dart';
import 'package:kactu/detailpage.dart';
import 'package:http/http.dart' as http;
import '../Util/style.dart';

// ignore: camel_case_types
class Actualite_Page extends StatefulWidget {
  const Actualite_Page({super.key});

  @override
  State<Actualite_Page> createState() => _Actualite_PageState();
}

// ignore: camel_case_types
class _Actualite_PageState extends State<Actualite_Page> {
  List<dynamic> post = [];
  bool _isLoading = false;

  Future<void> fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

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
    } else {
      setState(() {
        _isLoading = false;
      });
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
      // appBar: AppBar(
      //   title: Text('Actualités'),
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
                color: CouleurPrincipale,
              ),
            )
          : post.isEmpty
              ? Center(
                  child: Image.asset(
                    'assets/error.png',
                    width: 200,
                    height: 200,
                  ),
                )
              : RefreshIndicator(
                  color: CouleurPrincipale,
                  backgroundColor: Colors.black,
                  onRefresh: fetchPosts,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Top Artistes',
                              style: TitreStyle,
                            ),
                          ),
                        ),
                        const NewWidget(images: [
                          'assets/art/a.jpg',
                          'assets/art/g.jpg',
                          'assets/art/b.jpg',
                          'assets/art/f.jpg',
                          'assets/art/c.jpg',
                          'assets/art/d.jpg',
                          'assets/art/e.jpg',
                        ]),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Container(
                        //         width: 150,
                        //         height: 50,
                        //         color: Colors.red,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        ...List.generate(
                          post.length,
                          (index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return DetailPage(
                                    date: post[index]['dateN'],
                                    source: post[index]['source'],
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
                      ],
                    ),
                  ),
                ),
    );
  }
}
