import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appshop1/Pagesuse/Details_of_ordering_products.dart';

class ProductDetailScreen extends StatelessWidget {
  final DocumentSnapshot veggie;
  final User user;
  final DocumentSnapshot productDocument;

  void addToCart(DocumentSnapshot veggie) {
    FirebaseFirestore.instance.collection('cart').add({
      'userId': user.uid,
      'veggieId': veggie.id,
      'name': veggie['ชื่อผัก'],
      'price': veggie['ราคาผัก'],
      'quantity': 1,
    });
  }

  void purchaseItem(DocumentSnapshot veggie, BuildContext context) async {
    await FirebaseFirestore.instance.collection('orders').add({
      'userId': user.uid,
      'veggieId': veggie.id,
      'name': veggie['ชื่อผัก'],
      'price': veggie['ราคาผัก'],
      'quantity': 1,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    await updateStock(veggie.id);

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

  Future<void> updateStock(String veggieId) async {
    final veggieDoc =
        FirebaseFirestore.instance.collection('vegetable').doc(veggieId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(veggieDoc);
      if (!snapshot.exists) {
        throw Exception("Veggie does not exist!");
      }

      int newStock = snapshot['จำนวนสินค้า'] - 1;
      if (newStock < 0) {
        throw Exception("Not enough stock available!");
      }

      transaction.update(veggieDoc, {'จำนวนสินค้า': newStock});
    });
  }

  const ProductDetailScreen(
      {Key? key,
      required this.productDocument,
      required this.veggie,
      required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = productDocument.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['ชื่อผัก']),
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Image.network(
                    data['รูปผัก'],
                    width: 350,
                    height: 250,
                  )
                ],
              )),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // สีขอบ
                  width: 2.0, // ความหนาขอบ
                ),
              ),
              child: ListTile(
                title: Text(
                  data['ชื่อผัก'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25),
                ),
                subtitle: Text(
                  '${data['ราคาผัก']} บาท/กก.',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              data['จำนวนผัก'] > 0
                  ? 'สินค้าคงเหลือ: ${data['จำนวนผัก']}'
                  : 'สินค้าหมด',
              style: TextStyle(
                  fontSize: 20,
                  color: data['จำนวนผัก'] > 0 ? Colors.black : Colors.red),
            ),
            Expanded(
              child: SizedBox(),
            ),
            data['จำนวนผัก'] > 0
                ? Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          addToCart(veggie);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('ได้เพิ่มสินค้าลงตะกร้าแล้ว')),
                          );
                        },
                        child: SizedBox(
                          width: 161.4,
                          height: 75,
                          child: Container(
                            color: Colors.green,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.shopping_cart,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    'เพิ่มลงในตะกร้า',
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                    ),
                                  ),
                                ), // Text
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(),
                        child: SizedBox(
                          width: 250,
                          height: 75,
                          //คำสั่งในกล่องข้อความ
                          child: Padding(
                            padding: EdgeInsets.only(),
                            child: ElevatedButton(
                              child: Text("สั่งซื้อสินค้า",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
                                addToCart(veggie);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OrderConfirmationScreen(user: user)),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
