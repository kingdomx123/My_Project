import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appshop1/Pagesuse/Details_of_ordering_products.dart';

class Details1 extends StatefulWidget {
  final DocumentSnapshot veggie;
  final User user;

  const Details1({
    Key? key,
    required this.veggie,
    required this.user,
  }) : super(key: key);

  @override
  State<Details1> createState() => _Details1State();
}

class _Details1State extends State<Details1> {
  void addToCart(DocumentSnapshot veggie) {
    FirebaseFirestore.instance.collection('cart').add({
      'userId': widget.user.uid,
      'veggieId': veggie.id,
      'name': veggie['ชื่อผัก'],
      'price': veggie['ราคาผัก'],
      'quantity': 1,
    });
  }

  void purchaseItem(DocumentSnapshot veggie, BuildContext context) async {
    await FirebaseFirestore.instance.collection('orders').add({
      'userId': widget.user.uid,
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
        await cartCollection.where('userId', isEqualTo: widget.user.uid).get();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.veggie['ชื่อผัก']),
        backgroundColor: const Color.fromARGB(255, 216, 255, 171),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/number1.jpg'),
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
                    Image(
                      width: 350,
                      height: 250,
                      image: NetworkImage(widget.veggie['รูปผัก']),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: 350,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: ListTile(
                title: Text(
                  widget.veggie['ชื่อผัก'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
                subtitle: Text(
                  '${widget.veggie['ราคาผัก']} บาท/กก.',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    addToCart(widget.veggie);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ได้เพิ่มสินค้าลงตะกร้าแล้ว')),
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
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              'เพิ่มลงในตะกร้า',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
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
                    child: Padding(
                      padding: EdgeInsets.only(),
                      child: ElevatedButton(
                        child: Text(
                          "สั่งซื้อสินค้า",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          side: BorderSide(color: Colors.red, width: 2),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OrderConfirmationScreen(user: widget.user)),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
