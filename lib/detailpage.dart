import 'dart:convert';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kactu/Util/style.dart';
import 'package:line_icons/line_icon.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  DetailPage(
      {required this.desc,
      required this.auteur,
      required this.image1,
      required this.image2,
      required this.titre,
      required this.date,
      required this.source,
      categorie,
      required this.id,
      super.key});
  String image1;
  String image2;
  String desc;
  String date;
  String source;
  final String id;
  String titre;
  String auteur;
  @override
  // ignore: library_private_types_in_public_api
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
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

    _incrementViews();
    _fetchViews().then((views) {
      setState(() {
        _views = views;
      });
    });
  }

  int _views = 0; // Variable d'état pour stocker le nombre de vues
  Future<void> _incrementViews() async {
    try {
      var url = "https://royalrisingplus.com/ib_app/increment_views.php";
      Uri uri = Uri.parse(url);
      await http.post(uri, body: {
        "id": widget.id,
      });
    } catch (e) {
      debugPrint('Failed to increment views: $e');
    }
  }

  Future<int> _fetchViews() async {
    try {
      var url = "https://royalrisingplus.com/ib_app/get_views.php";
      Uri uri = Uri.parse(url);
      final response = await http.post(uri, body: {
        "id": widget.id,
      });
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['vues'];
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint('Failed to fetch views: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const FaIcon(FontAwesomeIcons.eye),
              Text(
                '$_views',
                style: DescStyle,
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              const url =
                  'https://play.google.com/store/apps/details?id=com.kactu';
              Share.share(
                  "Actu :$widget.titre},\n Description :${widget.desc}\n Telecharger l'Application IB App\n$url");
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
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 500,
                      child: Image.network(
                        "$Adress_IP/profil/${widget.image1}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              Text(widget.desc, style: DescStyle),

              Text(widget.date, style: DescStyle),

              ListTile(
                onTap: () {
                  // ignore: deprecated_member_use
                  launch(widget.source);
                },
                leading: const Icon(Icons.web),
                title: Text(
                  "Lien: ${widget.source}",
                  style: TextStyle(
                      fontWeight: FontWeight.w400, color: CouleurPrincipale),
                  textAlign: TextAlign.start,
                ),
                trailing: const Icon(Icons.architecture),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  "Auteur : ${widget.auteur}",
                  style: DescStyle,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 500,
                child: Image.network(
                  "$Adress_IP/profil/${widget.image2}",
                  fit: BoxFit.cover,
                ),
              ),

              const Divider(
                thickness: 1,
              ),
              // social(widget: widget),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class social extends StatelessWidget {
  const social({
    super.key,
    required this.widget,
  });

  final DetailPage widget;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            "Lien : ${widget.source}",
            style: const TextStyle(fontWeight: FontWeight.w400),
            textAlign: TextAlign.start,
          ),
          trailing: const Icon(Icons.architecture),
        ),
        ListTile(
          trailing: const Icon(Icons.architecture),
          leading: const Icon(Icons.person),
          title: Text(
            "Publier par : ${widget.auteur}",
            style: DescStyle,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: IconButton(
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.whatsapp,
                  size: 30,
                  color: Colors.green,
                ),
              ),
            ),
            Card(
              child: IconButton(
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.facebook,
                  size: 30,
                  color: Colors.blue,
                ),
              ),
            ),
            Card(
              child: IconButton(
                onPressed: () {},
                icon: FaIcon(
                  FontAwesomeIcons.instagram,
                  size: 30,
                  color: Colors.red.shade400,
                ),
              ),
            ),
            Card(
              child: IconButton(
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.linkedin,
                  size: 30,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        )
      ],
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
