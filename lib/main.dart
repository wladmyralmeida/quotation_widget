import 'package:flutter/material.dart';

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
          title: const Text('Transação'),
          centerTitle: true,
          backgroundColor: const Color(0xff091F4C),
        ),
        body: ConfirmarMovimentacaoWidget(),
      ),
    );
  }
}

class ConfirmarMovimentacaoWidget extends StatefulWidget {
  @override
  _ConfirmarMovimentacaoWidgetState createState() =>
      _ConfirmarMovimentacaoWidgetState();
}

class _ConfirmarMovimentacaoWidgetState
    extends State<ConfirmarMovimentacaoWidget> {
  final Map<String, dynamic> currencies = {
    'USD': {'label': 'Dólar', 'flag': 'assets/eua.png', 'rate': 1.0},
    'BRL': {'label': 'Real', 'flag': 'assets/br.png', 'rate': 5.0},
    'PYG': {'label': 'Guarani', 'flag': 'assets/gua.png', 'rate': 7000.0},
  };

  final Map<String, TextEditingController> controllers = {};
  double totalSent = 0.0;
  double amountDue = 100.0;

  @override
  void initState() {
    super.initState();
    currencies.forEach((key, _) {
      controllers[key] = TextEditingController();
    });
  }

  @override
  void dispose() {
    controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _calculateTotal() {
    double total = 0.0;
    currencies.forEach((key, value) {
      double rate = value['rate'];
      double amount = double.tryParse(controllers[key]?.text ?? '0') ?? 0;
      total += amount / rate;
    });

    setState(() {
      totalSent = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransactionSummary(),
          const Divider(color: Colors.white),
          const SizedBox(height: 16),
          ...currencies.entries.map((entry) {
            return _buildCurrencyRow(
              entry.key,
              entry.value['label'],
              entry.value['flag'],
              entry.value['rate'],
            );
          }).toList(),
          const SizedBox(height: 16),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildTransactionSummary() {
    double change = totalSent - amountDue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TransactionDetail(label: 'A Pagar', value: '\$100.00'),
        _TransactionDetail(
            label: 'Total Enviado', value: '\$${totalSent.toStringAsFixed(2)}'),
        _TransactionDetail(
            label: 'Troco', value: '\$${change.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildCurrencyRow(
      String code, String label, String flagPath, double rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildFlagIcon(flagPath),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          _buildValueInput('Valor em $label', controllers[code]!, rate),
          const SizedBox(height: 8),
          _buildCalculatedField('Total em USD', controllers[code]!, rate),
          const SizedBox(height: 8),
          _buildSuggestedChangeField('Troco sugerido', rate),
        ],
      ),
    );
  }

  Widget _buildFlagIcon(String flagPath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Image.asset(
        flagPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.flag, color: Colors.grey),
      ),
    );
  }

  Widget _buildValueInput(
      String hint, TextEditingController controller, double rate) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) => _calculateTotal(),
    );
  }

  Widget _buildCalculatedField(
      String label, TextEditingController controller, double rate) {
    double value = double.tryParse(controller.text) ?? 0;
    double equivalent = value / rate;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: \$${equivalent.toStringAsFixed(2)}',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildSuggestedChangeField(String label, double rate) {
    double change = totalSent - amountDue;
    double suggestedChange = change * rate;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: ${suggestedChange.toStringAsFixed(2)}',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Voltar'),
        ),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Avançando...')),
            );
          },
          child: const Text('Avançar'),
        ),
      ],
    );
  }
}

class _TransactionDetail extends StatelessWidget {
  final String label;
  final String value;

  const _TransactionDetail({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
        Text(value, style: const TextStyle(color: Colors.green, fontSize: 18)),
      ],
    );
  }
}
