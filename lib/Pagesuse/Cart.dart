import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  factory Product.fromDocument(DocumentSnapshot doc) {
    return Product(
      id: doc.id,
      name: doc['ชื่อผัก'],
      price: doc['ราคาผัก'],
    );
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class ShoppingCart {
  final List<CartItem> items = [];

  void addProduct(Product product) {
    for (var item in items) {
      if (item.product.id == product.id) {
        item.quantity++;
        return;
      }
    }
    items.add(CartItem(product: product));
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  void clear() {
    items.clear();
  }
}

class CartPage extends StatelessWidget {
  final ShoppingCart cart;
  final VoidCallback placeOrder;

  CartPage({required this.cart, required this.placeOrder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าสินค้า'),
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
        child: cart.items.isEmpty
            ? Center(
                child: Text(
                'ตะกร้าของท่านว่างเปล่า',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ))
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        CartItem item = cart.items[index];
                        return ListTile(
                          title: Text(item.product.name),
                          subtitle: Text('Quantity: ${item.quantity}'),
                          trailing: Text(
                              '\$${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                        Text('Total: \$${cart.totalPrice.toStringAsFixed(2)}'),
                  ),
                  ElevatedButton(
                    onPressed: placeOrder,
                    child: Text('Place Order'),
                  ),
                ],
              ),
      ),
    );
  }
}
