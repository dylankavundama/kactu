import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kactu/HomePage.dart';
import 'package:kactu/UI.dart';
import 'package:kactu/detailpage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Util/style.dart';

class Actualite_Page extends StatefulWidget {
  const Actualite_Page({super.key});

  @override
  State<Actualite_Page> createState() => _Actualite_PageState();
}

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
      savePostsLocally(resultat); // Save posts locally
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  Future<void> savePostsLocally(List<dynamic> posts) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('posts', jsonEncode(posts));
  }

  Future<void> loadPostsFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? postsString = prefs.getString('posts');
    if (postsString != null) {
      final List<dynamic> localPosts = jsonDecode(postsString);
      setState(() {
        post = localPosts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
    loadPostsFromLocalStorage(); // Load posts from local storage
    fetchPosts();
  }

  final bool _isLoaded = false;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-6009510012427568/6089806483'
      : 'ca-app-pub-6009510012427568/6089806483';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  void _loadAd() async {
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      return;
    }

    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  bool isFavorite = false;
  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Stack(
                          children: [
                            if (_bannerAd != null && _isLoaded)
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: SafeArea(
                                  child: SizedBox(
                                    width: _bannerAd!.size.width.toDouble(),
                                    height: _bannerAd!.size.height.toDouble(),
                                    child: AdWidget(ad: _bannerAd!),
                                  ),
                                ),
                              ),
                          ],
                        ),
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
