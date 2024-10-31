import 'package:flutter/material.dart';

class PaymentByAccount extends StatelessWidget {
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController transactionNumberController =
      TextEditingController();

  PaymentByAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("Número da Conta",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text("Número da Transação",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: accountNumberController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Obrigatório',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: transactionNumberController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Opcional',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
