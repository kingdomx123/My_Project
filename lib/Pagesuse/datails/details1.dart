import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Details1 extends StatefulWidget {
  const Details1({super.key});

  @override
  State<Details1> createState() => _Details1State();
}

class _Details1State extends State<Details1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Vegetable")
            .doc("N8Aa0WhtVr6qSXz6hW29")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              appBar: AppBar(
                //ชื่อมุมขวาบน
                title: Text(userData['ชื่อผัก']),
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
                          Image(
                            width: 350,
                            height: 250,
                            image: NetworkImage(userData['รูปผัก']),
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
                          userData['ชื่อผัก'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 25),
                        ),
                        subtitle: Text(
                          '${userData['ราคาผัก']} บาท/กก.',
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
    );
  }
}
