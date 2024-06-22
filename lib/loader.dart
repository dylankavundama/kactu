import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kactu/HomePage.dart';
import 'package:kactu/nav.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), page);
  }

  page() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => NavBarPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.2,
            ),
            Center(
              child: Image.asset('assets/logo.png'),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.build,
                size: 19,
                color: Colors.amber,
              ),
              label: const Text(
                'Copyright Kasindi-Lubiriha 2024',
                style: TextStyle(color: Colors.black),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16,
                  child: Image.asset('asset/sp/a.jpg'),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16,
                  child: Image.asset('asset/sp/b.png'),
                ),
                const Padding(padding: EdgeInsets.only(left: 10)),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 16,
                  child: Image.asset('asset/sp/c.png'),
                )
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
