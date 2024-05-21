import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appshop1/Home/myhomepage.dart';

class VeggieDetailScreen extends StatelessWidget {
  final DocumentSnapshot veggie;
  final User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Myhomepage_m()),
    );
  }

  VeggieDetailScreen({required this.veggie, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(veggie['ชื่อผัก']),
      ),
      body: Column(
        children: [
          Text(veggie['ชื่อผัก']),
          Text('Price: \$${veggie['ราคาผัก']}'),
          ElevatedButton(
            onPressed: () {
              addToCart(veggie);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${veggie['ชื่อผัก']} added to cart')),
              );
            },
            child: Text('Add to Cart'),
          ),
          ElevatedButton(
            onPressed: () {
              purchaseItem(veggie, context);
            },
            child: Text('Buy Now'),
          ),
          SizedBox(
            //คำสั่งในกล่องข้อความ
            child: Padding(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: ElevatedButton(
                child: Text("ออกจากระบบ",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.black87, width: 2),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('ยืนยันการออกจากระบบ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        content: Text('คุณต้องการที่จะออกจากระบบหรือไม่?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              // ปิดกล่องโต้ตอบ
                              Navigator.of(context).pop();
                            },
                            child: Text('ยกเลิก',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          TextButton(
                            onPressed: () async {
                              //await GoogleSignIn().signOut();
                              await _signOut(context);
                            },
                            child: Text('ยืนยัน',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addToCart(DocumentSnapshot veggie) {
    FirebaseFirestore.instance.collection('cart').add({
      'userId': user.uid,
      'name': veggie['ชื่อผัก'],
      'price': veggie['ราคาผัก'],
      'quantity': 1,
    });
  }

  void purchaseItem(DocumentSnapshot veggie, BuildContext context) async {
    await FirebaseFirestore.instance.collection('orders').add({
      'userId': user.uid,
      'name': veggie['ชื่อผัก'],
      'price': veggie['ราคาผัก'],
      'quantity': 1,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
    clearCart();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order placed and cart cleared')),
    );
  }

  void clearCart() async {
    final cartCollection = FirebaseFirestore.instance.collection('cart');
    final snapshot =
        await cartCollection.where('userId', isEqualTo: user.uid).get();
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
