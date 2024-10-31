import 'package:flutter/material.dart';
import 'package:quotation_widget/payment_forms/quotation_generic_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff091F4C),
        appBar: AppBar(
          title: const Text(
            'Transação',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff091F4C),
        ),
        body: const QuotationGenericWidget(),
      ),
    );
  }
}
