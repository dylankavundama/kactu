import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ibapp/HomePage.dart';


class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), page);
  }

  page() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) =>   HomePage()),
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
              child: Image.asset('asset/c.jpg'),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                Icons.new_releases_outlined,
                color: Colors.black,
              ),
              label: const Text(
                'From CFPI',
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
