import 'package:flutter/material.dart';

class Statistics_admin extends StatefulWidget {
  const Statistics_admin({super.key});

  @override
  State<Statistics_admin> createState() => _Statistics_adminState();
}

class _Statistics_adminState extends State<Statistics_admin> {
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
