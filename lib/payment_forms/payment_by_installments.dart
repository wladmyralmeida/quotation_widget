import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentByInstallments extends StatefulWidget {
  const PaymentByInstallments({super.key});

  @override
  _PaymentByInstallmentsState createState() => _PaymentByInstallmentsState();
}

class _PaymentByInstallmentsState extends State<PaymentByInstallments> {
  int installments = 1;
  DateTime dueDate = DateTime.now().add(const Duration(days: 30));

  void _updateDueDate() {
    setState(() {
      dueDate = DateTime.now().add(Duration(days: 30 * installments));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("Número de Parcelas",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text("Vencimento", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (installments > 1) installments--;
                          _updateDueDate();
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(
                            text: installments.toString()),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          int? newValue = int.tryParse(value);
                          if (newValue != null && newValue >= 1) {
                            setState(() {
                              installments = newValue;
                              _updateDueDate();
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          installments++;
                          _updateDueDate();
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: DateFormat('dd/MM/yyyy').format(dueDate),
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
