// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Util/style.dart';

// ignore: must_be_immutable
class ProductDetailPage extends StatefulWidget {
  String image1;
  String image2;
  String desc;
  String prix;
  String num;
  String id;
  String titre;
  String auteur;

  ProductDetailPage({
    required this.desc,
    required this.auteur,
    required this.image2,
    required this.titre,
    required this.prix,
    required this.image1,
    required this.num,
    categorie,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<dynamic> post = [];

  fetchPosts() async {
    setState(() {});

    var url = "$Adress_IP/boutique.php";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List resultat = jsonDecode(response.body);
      resultat.sort((a, b) => b["id"].compareTo(a["id"]));
      setState(() {
        post = resultat;
      });
      // Cache the data
      // prefs.setString('entreprise_data', response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }


  //banniere actu
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-6009510012427568/6089806483'
      : 'ca-app-pub-6009510012427568/6089806483';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isLoaded = false;
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
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
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

  @override
  void dispose() {
    _bannerAd?.dispose();

    super.dispose();
  }

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        title: Text(
          widget.titre,
          style: TitreStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: Image.network(
                        fit: BoxFit.cover,
                        "$Adress_IP/profil/${widget.image1}",
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      child: Image.network(
                        fit: BoxFit.cover,
                        "$Adress_IP/profil/${widget.image1}",
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1.0),
              Row(
                children: [
                  const Icon(Icons.person_3_outlined),
                  Text(
                    "Vendeur:${widget.auteur}",
                    style: SousTStyle,
                  ),
                ],
              ),
              Text(
                widget.titre,
                style: TitreStyle,
              ),
              Text(
                '\$${widget.prix}',
                style: TextStyle(fontSize: 20.0, color: CouleurPrincipale),
              ),
              const SizedBox(height: 5.0),
              Text(
                widget.desc,
                style: DescStyle,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      textStyle: TitreStyleWhite),
                  onPressed: () {
                    String url =
                        "https://wa.me/+243${widget.num}/?text=Bonjour,j'aimerai acheter le ${widget.titre} de ${widget.prix} \$";
                    // ignore: deprecated_member_use
                    launch(url);
                  },
                  child: const Text('WhatsApp'),
                ),
              ),
              const Divider(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: CouleurPrincipale,
                      textStyle: TitreStyle),
                  onPressed: () {
                    _makePhoneCall(widget.num);
                  },
                  child: const Text('SMS/APPEL'),
                ),
              ),
              //   const Spacer(),

              ...List.generate(
                post.length,
                (index) => GestureDetector(
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
                    child: Card(
                      child: ListTile(
                        trailing: Text(
                          "${post[index]['prix']} \$",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CouleurPrincipale),
                        ),
                        subtitle: Text(
                          "${post[index]['detail']} ",
                          style: SousTStyle,
                          maxLines: 1,
                        ),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            "$Adress_IP/profil/${post[index]['image1']}",
                          ),
                        ),
                        title: Text(
                          post[index]['nom'],
                          style: DescStyle,
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // ignore: deprecated_member_use
    if (await canLaunch(launchUri.toString())) {
      // ignore: deprecated_member_use
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $launchUri';
    }
  }
}
