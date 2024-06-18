import 'dart:convert';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:line_icons/line_icon.dart';
 
import 'package:share/share.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin_ib/Util/style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  DetailPage(
      {required this.desc,
      required this.auteur,
      required this.image1,
      required this.image2,
      required this.titre,
      categorie,
      required this.source,
      super.key});
  String image1;
  String image2;
  String desc;
  String titre;
  String source;
  String auteur;
  @override
  // ignore: library_private_types_in_public_api
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool fav = false;

  //banniere actu
  BannerAd? _bannerAd;

  bool _isLoaded = false;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-7329797350611067/5003791578'
      : 'ca-app-pub-7329797350611067/5003791578';

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

  // Function to toggle favorite status
  void toggleFavorite() async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //   List<String> favorites = prefs.getStringList('favorites') ?? [];
    String currentData = jsonEncode({
      'nom': widget.titre,
      'detail': widget.desc,
      'image1': widget.image1,
      'image2': widget.image2,
    });

    // setState(() {
    //   if (isFavorite) {
    //     favorites.remove(currentData);
    //   } else {
    //     favorites.add(currentData);
    //   }
    //   prefs.setStringList('favorites', favorites);
    //   isFavorite = !isFavorite;
    // });
  }

  // Function to check if current item is favorite
  void checkFavorite() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //   List<String> favorites = prefs.getStringList('favorites') ?? [];
    String currentData = jsonEncode({
      'nom': widget.titre,
      'detail': widget.desc,
      'image1': widget.image1,
      'image2': widget.image2,
      // Add more data if needed
    });
    setState(() {
      //isFavorite = favorites.contains(currentData);
    });
  }

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

// Sythese
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
 
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border_sharp,
              color: isFavorite ? Colors.teal : null,
            ),
            onPressed: toggleFavorite,
          ),
          IconButton(
            onPressed: () {
              const url =
                  'https://play.google.com/store/apps/details?id=com.ibapp';
              Share.share(
                  "Actu :${widget.titre},\n Description :${widget.desc}\n Telecharger l'Application IB App\n$url");
            },
            icon: const LineIcon(Icons.share_sharp),
          )
        ],
        iconTheme: IconThemeData(color: CouleurPrincipale),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 0),
            ),
            Text(
              'Description',
              style: DescStyle,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                child: Column(
                  children: [
                    // Center(
                    //   child: IconButton(
                    //     icon: Icon(
                    //       isFavorite ? Icons.favorite : Icons.favorite_border,
                    //       color: isFavorite ? Colors.red : null,
                    //     ),
                    //     onPressed: toggleFavorite,
                    //   ),
                    // ),
                    Text(widget.titre, style: TitreStyle),
                  ],
                ),
              ),
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
                child: Column(
                  children: [
                   Image.network(
                              "$Adress_IP/profil/${widget.image1}",
                              fit: BoxFit.cover,
                            ),Image.network(
                              "$Adress_IP/profil/${widget.image2}",
                              fit: BoxFit.cover,
                            ),
                  ],
                ),
              ),
              Text(widget.desc, style: TitreStyle),
              const Divider(
                thickness: 1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                      onTap: () {
                        // ignore: deprecated_member_use
                        launch('https://${widget.source}');
                      },
                      leading: const Icon(Icons.web),
                      title: Text(
                        "Source : ${widget.source}",
                        style: const TextStyle(fontWeight: FontWeight.w400),
                        textAlign: TextAlign.start,
                      ),
                      trailing: const Icon(Icons.architecture)),
                  ListTile(
                    trailing: const Icon(Icons.architecture),
                    leading: const Icon(Icons.person),
                    title: Text(
                      "Auteur : ${widget.auteur}",
                      style: DescStyle,
                    ),
                  ),
                 
                  
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 73,
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0.0,
          child: FittedBox(
            fit: BoxFit.none,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  // String lat = widget.lat;
                  // String long = widget.long;
                  // String url =
                  //     'http://www.google.com/maps/search/?api=1&query=$lat,$long';
                  // launch(url);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 6.0),
                  height: 46,
                  width: 186,
                  decoration: BoxDecoration(
                    color: CouleurPrincipale,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: const Text(
                    "Le Direct",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String titleText;
  final String trailingText;
  final VoidCallback onTap;

  const CustomListTile({
    super.key,
    required this.leadingIcon,
    required this.titleText,
    required this.trailingText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(leadingIcon),
      title: Text(
        titleText,
        style: DescStyle,
      ),
      trailing: Text(trailingText),
    );
  }
}
