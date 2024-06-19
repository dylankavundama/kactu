import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kactu/Util/style.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'model/actualite.dart';
import 'model/culture.dart';
import 'model/event.dart';
import 'model/sport.dart';
import 'model/tech.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
    _startNewGame();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _interstitialAd?.dispose();

    super.dispose();
  }

  InterstitialAd? _interstitialAd;
  final _gameLength = 5;
  late var _counter = _gameLength;

  final String _adUnitIdd = Platform.isAndroid
      ? 'ca-app-pub-6009510012427568/4123691533'
      : 'ca-app-pub-6009510012427568/4123691533';

  // ? '': '';

  void _startNewGame() {
    setState(() => _counter = _gameLength);

    _loadAdd();
    _starTimer();
  }

  void _loadAdd() {
    InterstitialAd.load(
      adUnitId: _adUnitIdd,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {},
            onAdImpression: (ad) {},
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            },
            onAdClicked: (ad) {},
          );

          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {},
      ),
    );
  }

  void _starTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _counter--);

      if (_counter == 0) {
        _interstitialAd?.show();
        timer.cancel();
      }
    });
  }

  void go() {
    setState(() {
      _interstitialAd?.show();
    });
  }

//////////////////////////////
  ///
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: CouleurPrincipale,
        statusBarBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      // drawer: SizedBox(
      //     width: MediaQuery.of(context).size.width * 0.6, child: Drawers()),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              iconTheme: IconThemeData(color: CouleurPrincipale),
              backgroundColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'K',
                      style: TextStyle(
                          color: CouleurPrincipale,
                          fontWeight: FontWeight.bold),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 0),
                    ),
                    const Text(
                      'ACTU',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                indicatorColor: CouleurPrincipale,
                labelColor: Colors.black,
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'A la une'),
                  Tab(text: 'Sport'),
                  Tab(text: 'événement'),
                  Tab(text: 'Culture'),
                  Tab(text: 'Tech'),
                ],
              ),
              floating: true,
              pinned: true,
              expandedHeight: 100.0,
              flexibleSpace: const FlexibleSpaceBar(),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const [
            Actualite_Page(),
            Sport_Page(),
            Event_Page(),
            Culture_Page(),
            Tech_Page(),
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: const Floating_Widget(),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required List<String> images,
  }) : _images = images;

  final List<String> _images;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
      ),
      items: _images.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 500,
              width: MediaQuery.of(context).size.width,
            );
          },
        );
      }).toList(),
    );
  }
}
