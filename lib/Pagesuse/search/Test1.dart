/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_appshop1/Home/Map_Screen.dart';
import 'package:flutter_appshop1/Home/welcomehome.dart';
import 'package:flutter_appshop1/auth/text_box.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final User user;

  OrderConfirmationScreen({required this.user});

  @override
  _OrderConfirmationScreenState createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("members");

  Future<void> editField1(String field) async {
    String newValue = "";
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );
    if (result != null) {
      setState(() {
        newValue = result;
      });
    }
    //คำสั่งอัพโหลดข้อมูลการแก้ไข
    if (newValue.trim().length > 0) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotal();
  }

  void _calculateTotal() async {
    QuerySnapshot cartSnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: widget.user.uid)
        .get();

    setState(() {
      totalAmount = cartSnapshot.docs.fold(0.0, (sum, item) {
        return sum + (item['price'] * item['quantity']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดยืนยันคำสั่งซื้อ'),
        backgroundColor: const Color.fromARGB(255, 216, 255, 171),
      ),
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
            SizedBox(
              height: 20,
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("members")
                  .doc(currentUser.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return MyTextBox1(
                    text: userData['ที่อยู๋'],
                    sectionName: 'ที่อยู่',
                    onPressed: () => editField1('ที่อยู๋'),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white, // สีพื้นหลัง
                  border: Border.all(
                    color: Colors.black, // สีขอบ
                    width: 2.0, // ความหนาของเส้นขอบ
                  ),
                  borderRadius: BorderRadius.circular(8.0), // รูปร่างขอบเขต
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 215),
                      child: Text(
                        "รายการทั้งหมด",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('cart')
                            .where('userId', isEqualTo: widget.user.uid)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final cartItems = snapshot.data!.docs;

                          double totalAmount = cartItems.fold(0, (sum, doc) {
                            return sum + (doc['price'] * doc['quantity']);
                          });

                          return Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  children: cartItems.map((doc) {
                                    return ListTile(
                                      title: Text(doc['name']),
                                      subtitle: Text(
                                          'ราคา: ${doc['price']} x ${doc['quantity']}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: () {
                                              _decrementQuantity(doc);
                                            },
                                          ),
                                          Text(doc['quantity'].toString()),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              _incrementQuantity(doc);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              _deleteItem(doc);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 40,
                  ),
                ),
                Text(
                  '    รายการสั่งซื้อทั้งหมด ',
                  style: TextStyle(fontSize: 16),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('cart')
                      .where('userId', isEqualTo: widget.user.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final cartItems = snapshot.data!.docs;

                    double totalAmount = cartItems.fold(0, (sum, doc) {
                      return sum + (doc['price'] * doc['quantity']);
                    });

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '                     ${totalAmount.toStringAsFixed(1)} บาท',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            /*Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Icon(
                    Icons.attach_money,
                    size: 40,
                  ),
                ),
                Text(
                  '    วิธีการชำระเงิน ',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),*/
            SizedBox(
              height: 165,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('cart')
                  .where('userId', isEqualTo: widget.user.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final cartItems = snapshot.data!.docs;

                return SizedBox(
                  width: double.infinity,
                  height: 75,
                  child: ElevatedButton(
                    child: Text("สั่งซื้อสินค้า",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            0), // ปรับเป็นค่าที่คุณต้องการ
                      ),
                      side: BorderSide(color: Colors.red, width: 2),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _purchaseItems(cartItems);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _incrementQuantity(DocumentSnapshot doc) async {
    DocumentSnapshot veggieDoc = await FirebaseFirestore.instance
        .collection('Vegetable')
        .doc(doc['veggieId'])
        .get();

    int stock = veggieDoc['จำนวนผัก'];
    int newQuantity = doc['quantity'] + 1;

    if (newQuantity <= stock) {
      await doc.reference.update({'quantity': newQuantity});
      _calculateTotal();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถเพิ่มจำนวนสินค้าได้มากกว่านี้')),
      );
    }
  }

  void _decrementQuantity(DocumentSnapshot doc) async {
    int newQuantity = doc['quantity'] - 1;
    if (newQuantity > 0) {
      await doc.reference.update({'quantity': newQuantity});
    } else {
      await doc.reference.delete();
    }
    _calculateTotal();
  }

  void _deleteItem(DocumentSnapshot doc) async {
    await doc.reference.delete();
    _calculateTotal();
  }

  void _purchaseItems(List<DocumentSnapshot> cartItems) async {
    // ดึงข้อมูลที่อยู่ผู้ใช้
    DocumentSnapshot userDoc =
        await usersCollection.doc(currentUser.email).get();
    String userAddress = userDoc['ที่อยู๋'];

    final batch = FirebaseFirestore.instance.batch();
    for (var item in cartItems) {
      batch.set(FirebaseFirestore.instance.collection('orders').doc(), {
        'userId': widget.user.uid,
        'veggieId': item['veggieId'],
        'name': item['name'],
        'price': item['price'],
        'quantity': item['quantity'],
        'status': 'รอการอนุมัติ',
        'ที่อยู่': userAddress, // เพิ่มที่อยู๋ผู้ใช้ในออเดอร์
        'timestamp': FieldValue.serverTimestamp(),
      });

      final veggieDoc = FirebaseFirestore.instance
          .collection('Vegetable')
          .doc(item['veggieId']);
      batch.update(
          veggieDoc, {'จำนวนผัก': FieldValue.increment(-item['quantity'])});
    }

    await batch.commit();

    _clearCart();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('สั่งซื้อเรียบร้อยแล้ว')),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Welcomehome(),
      ),
    );
  }

  void _clearCart() async {
    final cartCollection = FirebaseFirestore.instance.collection('cart');
    final snapshot =
        await cartCollection.where('userId', isEqualTo: widget.user.uid).get();
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}*/
