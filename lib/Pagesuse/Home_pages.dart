import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_appshop1/Pagesuse/Cart.dart';
import 'package:flutter_appshop1/Pagesuse/search/Search_veg.dart';
import 'package:flutter_appshop1/Widgets/ProductDetailScreen.dart';
import 'package:flutter_appshop1/Widgets/PopularItemsWidget.dart';
import 'package:flutter_appshop1/Widgets/PopularItemsWidget_v2.dart';

class Home_v extends StatefulWidget {
  @override
  State<Home_v> createState() => _Home_vState();
}

class _Home_vState extends State<Home_v> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection("Vegetable").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "ชื่อผัก": qn.docs[i]["ชื่อผัก"],
          "ราคาผัก": qn.docs[i]["ราคาผัก"],
          "รูปผัก": qn.docs[i]["รูปผัก"],
        });
      }
    });

    return qn.docs;
  }

  @override
  void initState() {
    fetchProducts();
    super.initState();
    _fetchImagesFromFirestore();
  }

  void _openProductDetailPage(
      BuildContext context, DocumentSnapshot productDocument) {
    // สร้างหน้าต่างใหม่เพื่อแสดงรายละเอียดของสินค้า
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          productDocument: productDocument,
          veggie: productDocument,
          user: currentUser,
        ),
      ),
    );
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<String> imageUrls = [];

  Future<void> _fetchImagesFromFirestore() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Promotion_img').get();
    setState(() {
      imageUrls =
          querySnapshot.docs.map((doc) => doc['รูป'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color.fromARGB(255, 200, 226, 202),
      body: Container(
        //alignment: Alignment.center,
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
              padding: EdgeInsets.only(top: 10, left: 20, bottom: 15),
              child: Text(
                "สวนคุณคำบุญ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SearchForm();
                    }));
                  },
                  child: Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.search,
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Text(
                                "ค้นหาสินค้าได้ตรงนี้",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CartScreen(
                        user: currentUser,
                      ),
                    ));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            imageUrls.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      CarouselSlider(
                        items: imageUrls.map((url) {
                          return Container(
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: NetworkImage(url),
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        }).toList(),
                        carouselController: _controller,
                        options: CarouselOptions(
                          height: 200,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imageUrls.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                "สินค้าผักแนะนำของทางสวน",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            PopularItemsWidget(),
            PopularItemsWidget_v2(),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: Text(
                "สินค้าผักทั้งหมด",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Vegetable')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Text('ไม่พบข้อมูลสินค้า');
                }
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 ช่องต่อแถว
                    crossAxisSpacing: 8.0, // ระยะห่างระหว่างช่องแนวแกน X
                    mainAxisSpacing: 8.0, // ระยะห่างระหว่างแถวแนวแกน Y
                  ),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        _openProductDetailPage(context, document);
                      },
                      child: Card(
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 2,
                              child: Container(
                                color: Colors.white,
                                child: Image.network(data['รูปผัก']),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              data['ชื่อผัก'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '${data['ราคาผัก']} บาท/กก.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
