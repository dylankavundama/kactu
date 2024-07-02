// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:kactu/Util/style.dart';

// ignore: camel_case_types
class Widget_UI extends StatefulWidget {
  const Widget_UI({
    Key? key,
    required this.image,
    required this.id,
    required this.titre,
    required this.desc,
    required this.date,
    this.maxLength = 60,
  }) : super(key: key);

  final String image;
  final String titre;
  final String desc;
  final String id;
  final String date;
  final int maxLength;

  @override
  State<Widget_UI> createState() => _Widget_UIState();
}

class _Widget_UIState extends State<Widget_UI> {
  bool fav = false;

  @override
  void dispose() {
    super.dispose();
  }

  bool isFavorite = false;

  // Function to toggle favorite status

  // Function to check if current item is favorite

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
      print('Failed to increment views: $e');
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
      print('Failed to fetch views: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    String displayedText = widget.titre.length <= widget.maxLength
        ? widget.titre
        : '${widget.titre.substring(0, widget.maxLength)}...';
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                displayedText,
                style: DescStyle,
                maxLines: 2,
              ),
            ),
            Text(
              widget.desc,
              style: SousTStyle,
              maxLines: 2,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            // Prend toute la taille de l'écran
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.30,
            // Enfant : Image
            child: Image.network(
              "$Adress_IP/profil/${widget.image}",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    'Erreur de chargement de l\'image',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   date,
            //   style: SousTStyle,
            // ),

            TextButton(
              onPressed: () {
                const url =
                    'https://play.google.com/store/apps/details?id=com.kactu';
                Share.share(
                    "✨✨✨KACTU✨✨✨ :${widget.titre},\n Description :${widget.desc}\n Telecharger l'Application Kactu pour plus d'info\n$url");
              },
              child: Text(
                '',
                style: SousTStyle,
              ),
            ),
            TextButton(
                 onPressed: () {
                const url =
                    'https://play.google.com/store/apps/details?id=com.kactu';
                Share.share(
                    "✨✨✨KACTU✨✨✨ :${widget.titre},\n Description :${widget.desc}\n Telecharger l'Application Kactu pour plus d'info\n$url");
              },
              child: Text(
                'Partager',
                style: SousTStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    FaIcon(FontAwesomeIcons.eye,size: 19,color: CouleurPrincipale,),
                  Text(
                    '$_views',
                    style: SousTStyle,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
