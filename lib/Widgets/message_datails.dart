import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message_datails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class Message_datailsScreen extends StatelessWidget {
  final DocumentSnapshot productDocument;

  const Message_datailsScreen({Key? key, required this.productDocument})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = productDocument.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['หัวเรื่อง']),
        backgroundColor: const Color.fromARGB(255, 216, 255, 171),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/number1.jpg'), // Replace this with your image asset
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.white, // สีพื้นหลัง
                  border: Border.all(
                    color: Colors.black, // สีขอบ
                    width: 2.0, // ความหนาของเส้นขอบ
                  ),
                  borderRadius: BorderRadius.circular(8.0), // รูปร่างขอบเขต
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 10, bottom: 15),
                      child: Text(
                        "รายละเอียดโปรโมชั่น",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        data['ข้อมูลโปรโมชั่น'].toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
