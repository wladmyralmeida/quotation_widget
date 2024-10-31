import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentByInstallments extends StatefulWidget {
  const PaymentByInstallments({super.key});

  @override
  _PaymentByInstallmentsState createState() => _PaymentByInstallmentsState();
}

class _PaymentByInstallmentsState extends State<PaymentByInstallments> {
  int installments = 1;
  double installmentAmount = 50.0; // Valor inicial da parcela
  final double interestRate = 0.02; // Taxa de juros para cada parcela (2%)
  final TextEditingController installmentsController = TextEditingController();
  final List<double> installmentValues = []; // Armazena valores de cada parcela
  final List<DateTime> dueDates =
      []; // Armazena datas de vencimento de cada parcela

  @override
  void initState() {
    super.initState();
    installmentsController.text = installments.toString();
    _initializeInstallments();
  }

  @override
  void dispose() {
    installmentsController.dispose();
    super.dispose();
  }

  void _initializeInstallments() {
    installmentValues.clear();
    dueDates.clear();
    for (int i = 1; i <= installments; i++) {
      installmentValues.add(_calculateInstallmentValue(i));
      dueDates.add(_calculateDueDate(i));
    }
  }

  void _incrementInstallments() {
    setState(() {
      installments++;
      installmentsController.text = installments.toString();
      installmentValues.add(_calculateInstallmentValue(installments));
      dueDates.add(_calculateDueDate(installments));
    });
  }

  void _decrementInstallments() {
    setState(() {
      if (installments > 1) {
        installments--;
        installmentsController.text = installments.toString();
        installmentValues.removeLast();
        dueDates.removeLast();
      }
    });
  }

  double _calculateInstallmentValue(int installmentIndex) {
    return installmentAmount * (1 + interestRate * installmentIndex);
  }

  DateTime _calculateDueDate(int installmentIndex) {
    return DateTime.now().add(Duration(days: 30 * installmentIndex));
  }

  void _editInstallmentValue(int index) {
    TextEditingController valueController = TextEditingController(
      text: installmentValues[index].toStringAsFixed(2),
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit, color: Colors.blueAccent),
                  const SizedBox(width: 8),
                  const Text(
                    "Editar Valor da Parcela",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Valor da Parcela",
                  labelStyle: const TextStyle(color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: () {
                      setState(() {
                        installmentValues[index] =
                            double.tryParse(valueController.text) ??
                                installmentValues[index];
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editDueDate(int index) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: dueDates[index],
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(const Duration(days: 365 * 5)), // Limite de 5 anos
    );

    if (selectedDate != null) {
      setState(() {
        dueDates[index] = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Número de Parcelas",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Colors.blueAccent),
                      onPressed: _decrementInstallments,
                    ),
                    Expanded(
                      child: TextField(
                        controller: installmentsController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          int? newValue = int.tryParse(value);
                          if (newValue != null && newValue >= 1) {
                            setState(() {
                              installments = newValue;
                              _initializeInstallments();
                            });
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: Colors.blueAccent),
                      onPressed: _incrementInstallments,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Center(
            child: Text(
              textAlign: TextAlign.center,
              "Detalhes das Parcelas",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Center(
            child: Text(
              textAlign: TextAlign.center,
              "(toque nos valores para editar)",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 22),
          Expanded(
            child: ListView.builder(
              itemCount: installments,
              itemBuilder: (context, index) {
                double installmentValue = installmentValues[index];
                DateTime dueDate = dueDates[index];

                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () => _editInstallmentValue(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.edit,
                                color: Colors.blueAccent, size: 16),
                            Text(
                              'R\$${installmentValue.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    subtitle: GestureDetector(
                      onTap: () => _editDueDate(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.blueAccent, size: 16),
                            Text(
                              'Vencimento: ${DateFormat('dd/MM/yyyy').format(dueDate)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
