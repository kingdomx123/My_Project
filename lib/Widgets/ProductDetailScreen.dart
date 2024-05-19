import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ProductDetailScreen extends StatelessWidget {
  final DocumentSnapshot productDocument;

  const ProductDetailScreen({Key? key, required this.productDocument})
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
            Expanded(
              child: SizedBox(),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    /*Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Myhomepage_m()),
                              );*/
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
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              'เพิ่มลงในตะกร้า',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
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
                        onPressed: () {},
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
