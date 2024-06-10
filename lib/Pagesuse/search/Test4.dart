import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingScreen extends StatefulWidget {
  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Tracking'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'approved')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!.docs;

          return ListView(
            children: orders.map((doc) {
              return ListTile(
                title: Text(doc['name']),
                subtitle: Text(
                    'Quantity: ${doc['quantity']}\nTotal Price: \$${doc['price'] * doc['quantity']}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    _completeOrder(doc.id);
                  },
                  child: Text('Complete'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _completeOrder(String orderId) {
    FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order marked as completed')),
    );
  }
}
