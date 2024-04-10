import 'package:flutter/material.dart';

class Store extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sport Store'),
      ),
      body: ListView(
        children: const  [
          ProductCard(
            productName: 'Football',
            productPrice: '\$20',
            productImage: 'assets/football.jpg',
          ),
          ProductCard(
            productName: 'Basketball',
            productPrice: '\$25',
            productImage: 'assets/basketball.jpg',
          ),
          ProductCard(
            productName: 'Tennis Racket',
            productPrice: '\$50',
            productImage: 'assets/tennis_racket.jpg',
          ),
          // Add more ProductCard widgets for additional products
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String productName;
  final String productPrice;
  final String productImage;

  const ProductCard({
    required this.productName,
    required this.productPrice,
    required this.productImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(
          productImage,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(productName),
        subtitle: Text(productPrice),
        trailing: ElevatedButton(
          onPressed: () {
            // Add functionality to buy the product
          },
          child: const Text('Buy'),
        ),
      ),
    );
  }
}
