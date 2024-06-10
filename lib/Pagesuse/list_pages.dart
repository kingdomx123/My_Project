import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserOrdersScreen extends StatefulWidget {
  @override
  _UserOrdersScreenState createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Padding(
              padding: EdgeInsets.only(
                top: 50,
                right: 230,
              ),
              child: Text(
                "รายการสินค้า",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('userId', isEqualTo: currentUser.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final orders = snapshot.data!.docs;

                  return ListView(
                    children: orders.map((doc) {
                      return Card(
                        color: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(doc['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('จำนวน: ${doc['quantity']} กก.'),
                              Text(
                                  'ราคารวม: ${doc['price'] * doc['quantity']} บาท'),
                              Text('สถานะ: ${doc['status']}'),
                            ],
                          ),
                          trailing: doc['status'] == 'รอการอนุมัติ'
                              ? ElevatedButton(
                                  onPressed: () {
                                    _cancelOrder(doc.id, doc['veggieId'],
                                        doc['quantity']);
                                  },
                                  child: Text('ยกเลิก'),
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _cancelOrder(String orderId, String productId, int quantity) async {
    DocumentReference productRef =
        FirebaseFirestore.instance.collection('Vegetable').doc(productId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot productSnapshot = await transaction.get(productRef);
      if (!productSnapshot.exists) {
        throw Exception("ไม่พบสินค้า");
      }
      int newStock = productSnapshot['จำนวนผัก'] + quantity;
      transaction.update(productRef, {'จำนวนผัก': newStock});
    });

    // Delete the order
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('คำสั่งซื้อถูกยกเลิกแล้ว')),
    );
  }
}
