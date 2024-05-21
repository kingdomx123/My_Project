import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class List_P extends StatefulWidget {
  const List_P({super.key});

  @override
  State<List_P> createState() => _List_PState();
}

class _List_PState extends State<List_P> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final usersCollection = FirebaseFirestore.instance.collection("orders");

  final CollectionReference _Vegetable =
      FirebaseFirestore.instance.collection("orders");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
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
            StreamBuilder(
              stream: _Vegetable.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      key: formKey,
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return Card(
                          color: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(
                              documentSnapshot['name'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                                '${documentSnapshot['price']} บาท/กก.                                                  จำนวน  ${documentSnapshot['quantity']} กก.'
                                    .toString()),
                          ),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
