import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appshop1/Home/Map_Screen.dart';
import 'package:flutter_appshop1/auth/text_box.dart';

class EditAddressScreen extends StatefulWidget {
  @override
  _EditAddressScreenState createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  void incrementQuantity(DocumentSnapshot doc) async {
    DocumentSnapshot veggieDoc = await FirebaseFirestore.instance
        .collection('Vegetable')
        .doc(doc['veggieId'])
        .get();

    int stock = veggieDoc['จำนวนผัก'];
    int newQuantity = doc['quantity'] + 1;

    if (newQuantity <= stock) {
      doc.reference.update({'quantity': newQuantity});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถเพิ่มมากกว่าสต็อกที่มีอยู่')),
      );
    }
  }

  void decrementQuantity(DocumentSnapshot doc) {
    int newQuantity = doc['quantity'] - 1;
    if (newQuantity > 0) {
      doc.reference.update({'quantity': newQuantity});
    } else {
      deleteItem(doc);
    }
  }

  void deleteItem(DocumentSnapshot doc) {
    doc.reference.delete();
  }

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
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('cart')
                          .where(
                            'userId',
                          )
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView(
                          children: snapshot.data!.docs.map((doc) {
                            return ListTile(
                              title: Text(doc['name']),
                              subtitle: Text('Price: \$${doc['price']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      decrementQuantity(doc);
                                    },
                                  ),
                                  Text(doc['quantity'].toString()),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      incrementQuantity(doc);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      deleteItem(doc);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
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
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
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
            ),
            SizedBox(
              height: 150,
            ),
            SizedBox(
              width: double.infinity,
              height: 75,
              //คำสั่งในกล่องข้อความ
              child: Padding(
                padding: EdgeInsets.only(),
                child: ElevatedButton(
                  child: Text("สั่งซื้อสินค้า",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0), // ปรับเป็นค่าที่คุณต้องการ
                    ),
                    side: BorderSide(color: Colors.red, width: 2),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    /*Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAddressScreen()),
                    );*/
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
