import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  OrderDetailScreen({required this.orderId});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดลูกค้า'),
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
        child: ListView(
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('orders')
                  .doc(widget.orderId)
                  .get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('ไม่พบข้อมูลการสั่งซื้อ'));
                }

                var doc = snapshot.data!;

                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ชื่อลูกค้า: ${doc['ชื่อลูกค้า']}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('นามสกุลลูกค้า: ${doc['นามสกุลลูกค้า']}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('เบอร์ลูกค้า: ${doc['เบอร์โทรศัพท์']}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('ที่อยู่ลูกค้า: ${doc['ที่อยู่']}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('ชื่อผัก: ${doc['name']}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('จำนวนที่สั่ง: ${doc['quantity']}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('ราคารวม: ${doc['price'] * doc['quantity']} บาท',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('สถานะการสั่งซื้อ: ${doc['status']}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 390),
                      _buildActionButton(doc),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(DocumentSnapshot doc) {
    String status = doc['status'];

    if (status == 'รอการอนุมัติ') {
      return SizedBox(
        width: double.infinity,
        height: 75,
        child: ElevatedButton(
          child: Text("อนุมัติ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            side: BorderSide(color: Colors.red, width: 2),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            await _updateOrderStatus(doc.id, 'อนุมัติแล้ว');
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      );
    } else if (status == 'อนุมัติแล้ว') {
      return SizedBox(
        width: double.infinity,
        height: 75,
        child: ElevatedButton(
          child: Text("การสั่งซื้อเสร็จสิ้น",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            side: BorderSide(color: Colors.red, width: 2),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: () async {
            await _updateOrderStatus(doc.id, 'การสั่งซื้อเสร็จสิ้น');
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
      );
    } else {
      return Container(); // ไม่ต้องการ action สำหรับคำสั่งซื้อที่เสร็จสิ้นแล้ว
    }
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
        'status': newStatus,
        '${newStatus}At': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('สถานะการสั่งซื้อได้รับการอัปเดตเป็น $newStatus')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาดในการอัปเดตสถานะ: $error')),
        );
      }
    }
  }
}
