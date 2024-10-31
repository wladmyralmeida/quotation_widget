import 'package:flutter/material.dart';
import 'payment_forms/payment_by_account.dart';
import 'payment_forms/payment_by_cash.dart';
import 'payment_forms/payment_by_installments.dart';

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
        body: const ConfirmarMovimentacaoWidget(),
      ),
    );
  }
}

class ConfirmarMovimentacaoWidget extends StatefulWidget {
  const ConfirmarMovimentacaoWidget({super.key});

  @override
  _ConfirmarMovimentacaoWidgetState createState() =>
      _ConfirmarMovimentacaoWidgetState();
}

class _ConfirmarMovimentacaoWidgetState
    extends State<ConfirmarMovimentacaoWidget> {
  String? _selectedPaymentType = 'Dinheiro';
  double totalSent = 0.0;
  double totalChange = 0.0;
  double amountDue = 100.0;

  // Função para atualizar o total enviado
  void _updateTotalSent(double newTotal) {
    setState(() {
      totalSent = newTotal;
    });
  }

  // Função para atualizar o total de troco
  void _updateTotalChange(double newTotalChange) {
    setState(() {
      totalChange = newTotalChange;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8.0,
        margin: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTransactionSummary(),
              const Divider(color: Colors.grey),
              _buildPaymentOptions(),
              const Divider(color: Colors.grey),
              Expanded(child: _buildConditionalFields()),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => _showConfirmationDialog(context),
                child: const Text(
                  'Realizar Venda',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionSummary() {
    double change = totalSent -
        amountDue; // Calcular troco total com base no total enviado e a pagar

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TransactionDetail(
            label: 'A Pagar', value: '\$${amountDue.toStringAsFixed(2)}'),
        _TransactionDetail(
            label: 'Pago',
            value: '\$${totalSent.toStringAsFixed(2)}',
            color: Colors.green),
        _TransactionDetail(
            label: 'Troco',
            value: '\$${totalChange.toStringAsFixed(2)}',
            color: Colors.red),
        _TransactionDetail(
            label: 'Total Enviado',
            value: '\$${(totalSent - totalChange).toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildPaymentOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPaymentOption('Dinheiro'),
        _buildPaymentOption('Conta'),
        _buildPaymentOption('A Prazo'),
      ],
    );
  }

  Widget _buildPaymentOption(String paymentType) {
    return Row(
      children: [
        Radio<String>(
          value: paymentType,
          groupValue: _selectedPaymentType,
          onChanged: (value) {
            setState(() {
              _selectedPaymentType = value;
            });
          },
        ),
        Text(paymentType),
      ],
    );
  }

  Widget _buildConditionalFields() {
    switch (_selectedPaymentType) {
      case 'Conta':
        return PaymentByAccount();
      case 'A Prazo':
        return PaymentByInstallments();
      default:
        return PaymentByCash(
          onTotalChange: _updateTotalSent,
          onTotalChangeForChange:
              _updateTotalChange, // Passar callback para atualizar o troco total
        );
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: Text(
              'Você selecionou o método de pagamento: $_selectedPaymentType. Deseja confirmar a transação?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transação confirmada!')),
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }
}

class _TransactionDetail extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _TransactionDetail({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        Text(value,
            style: TextStyle(fontSize: 18, color: color ?? Colors.black)),
      ],
    );
  }
}
