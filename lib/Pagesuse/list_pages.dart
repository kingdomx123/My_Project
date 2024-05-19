import 'package:flutter/material.dart';

class List_P extends StatefulWidget {
  const List_P({super.key});

  @override
  State<List_P> createState() => _List_PState();
}

class _List_PState extends State<List_P> {
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
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10, bottom: 15),
              child: Text(
                "รายการสินค้า",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
