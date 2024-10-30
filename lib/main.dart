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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Deseja confirmar a transação?'),
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
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.6,
                  children: currencies.entries.map((entry) {
                    String code = entry.key;
                    String label = entry.value['label'];
                    String flagPath = entry.value['flag'];
                    double rate = entry.value['rate'];
                    return _buildCurrencyBlock(code, label, flagPath, rate);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              _buildConfirmButton(context),
            ],
          ),
        ),
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
            label: 'Pago', value: '\$54.50', color: Colors.green),
        _TransactionDetail(label: 'Troco', value: '\$52.00', color: Colors.red),
        _TransactionDetail(
            label: 'Total Enviado', value: '\$${totalSent.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildCurrencyBlock(
      String code, String label, String flagPath, double rate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildFlagIcon(flagPath),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        _buildLabeledField('Valor', _buildValueInput(controllers[code]!, rate)),
        const SizedBox(height: 8),
        _buildLabeledField(
            'Total em Dólar', _buildCalculatedField(controllers[code]!, rate)),
        const SizedBox(height: 8),
        _buildLabeledField('Troco Sugerido', _buildSuggestedChangeField(rate)),
      ],
    );
  }

  Widget _buildLabeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        field,
      ],
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

  Widget _buildValueInput(TextEditingController controller, double rate) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) => _calculateTotal(),
    );
  }

  Widget _buildCalculatedField(TextEditingController controller, double rate) {
    double value = double.tryParse(controller.text) ?? 0;
    double equivalent = value / rate;

    return Text(
      '\$${equivalent.toStringAsFixed(2)}',
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildSuggestedChangeField(double rate) {
    double change = totalSent - amountDue;
    double suggestedChange = change * rate;

    return Text(
      '\$${suggestedChange.toStringAsFixed(2)}',
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showConfirmationDialog(context),
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 16, color: Colors.black)),
      ),
      child: const Text(
        'Confirmar',
        style: TextStyle(color: Colors.black),
      ),
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
