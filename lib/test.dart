import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'MyTest page',
          style: TextStyle(color: Colors.red, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              NewWidget(
                nn: 'ttt',
                nom: 'Twat',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class NewWidget extends StatelessWidget {
  NewWidget({super.key, required this.nom, required this.nn});
  String nom;

  String nn;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.40,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
