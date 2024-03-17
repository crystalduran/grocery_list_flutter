import 'package:flutter/material.dart';
import 'package:crystal_tarea_siete/screens/products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Persistence',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const ProductsScreen(),
    );
  }
}