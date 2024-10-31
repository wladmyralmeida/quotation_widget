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
          Column(
            children: [
              const Text("Número da Conta",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: accountNumberController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_balance,
                      color: Colors.blueAccent),
                  labelText: 'Obrigatório',
                  labelStyle: const TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
              const SizedBox(height: 22),
              const Text("Número da Transação",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: transactionNumberController,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.receipt_long, color: Colors.blueAccent),
                  labelText: 'Opcional',
                  labelStyle: const TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
