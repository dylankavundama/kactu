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
                nom: 'Twat',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  NewWidget({super.key, required this.nom});
  String nom;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.40,
        color: Colors.orange,
      ),
    );
  }
}
