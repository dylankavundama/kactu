import 'package:flutter/material.dart';
import 'package:kactu/HomePage.dart';
import 'package:kactu/Util/style.dart';
import 'package:kactu/boutique/login/login.dart';
import 'package:kactu/channel.dart';
import 'package:kactu/model/boutique.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key});
  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  int currentindex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;
  List<Widget> screen = [
    HomePage(),
    // Channel(),
    const Boutique(),
    const LoginHome(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Text(
      //         'IB',
      //         style: TextStyle(color: CouleurPrincipale),
      //       ),
      //       const Padding(
      //         padding: EdgeInsets.only(right: 0),
      //       ),
      //       const Text(
      //         'APP',
      //         style: TextStyle(color: Colors.black),
      //       ),
      //     ],
      //   ),
      //   centerTitle: true,
      //   elevation: 1,
      // ),
      bottomSheet: screen[currentindex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        //  backgroundColor: Colors.grey.shade100,
        labelBehavior: labelBehavior,
        selectedIndex: currentindex,
        onDestinationSelected: (int index) {
          setState(() {
            currentindex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              size: 25,
            ),
            selectedIcon: Icon(
              Icons.home,
              size: 25,
            ),
            label: 'Acceuil',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_cart_outlined,
              size: 25,
            ),
            selectedIcon: Icon(
              Icons.shopping_cart,
              size: 25,
            ),
            label: 'Boutique',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outlined,
              size: 25,
            ),
            selectedIcon: Icon(
              Icons.person,
              size: 25,
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
