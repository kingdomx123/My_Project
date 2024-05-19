import 'package:flutter/material.dart';

class Oder_admin extends StatefulWidget {
  const Oder_admin({super.key});

  @override
  State<Oder_admin> createState() => _Oder_adminState();
}

class _Oder_adminState extends State<Oder_admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/number1.jpg'), // Replace this with your image asset
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
