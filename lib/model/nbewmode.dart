import 'package:flutter/material.dart';

class Te3stFriday extends StatefulWidget {
  const Te3stFriday({super.key});

  @override
  State<Te3stFriday> createState() => _Te3stFridayState();
}

class _Te3stFridayState extends State<Te3stFriday> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.30,
            color: Colors.red,
          )
        ],
      ),
    );
  }
}
