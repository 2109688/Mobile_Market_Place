import 'package:flutter/material.dart';
import 'package:market_place/HomePage.dart';
import 'package:market_place/Login.dart';
import 'package:market_place/Registration.dart';
import 'package:market_place/UserPage.dart';

void main() {
  runApp(MaterialApp(
    home: Main(),
  ));
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  int _currentIndex = 0;


  final List<Widget> _children = [
  HomePage(),Login(),Registration(),UserPage()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.teal,
        //iconSize: 30,
        //selectedFontSize: 15,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("HomePage"),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            title: Text("Login"),
            backgroundColor: Colors.grey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            title: Text("Registration"),
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("UserPage"),
            backgroundColor: Colors.pink,
          ),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
