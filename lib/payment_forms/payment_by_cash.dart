import 'package:flutter/material.dart';

class PaymentByCash extends StatefulWidget {
  final ValueChanged<double> onTotalChange;

  const PaymentByCash({super.key, required this.onTotalChange});

  @override
  _PaymentByCashState createState() => _PaymentByCashState();
}

class _PaymentByCashState extends State<PaymentByCash> {
  final Map<String, dynamic> currencies = {
    'USD': {'label': 'Dólar', 'flag': 'assets/eua.png', 'rate': 1.0},
    'BRL': {'label': 'Real', 'flag': 'assets/br.png', 'rate': 5.0},
    'PYG': {'label': 'Guarani', 'flag': 'assets/gua.png', 'rate': 7000.0},
  };

  final Map<String, TextEditingController> controllers = {};
  double amountDue =
      100.0; // Valor total a ser pago, usado para calcular troco sugerido

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
    widget.onTotalChange(total);
  }

  double _calculateSuggestedChange(double amountSent, double rate) {
    double equivalentInDollar = amountSent / rate;
    return (equivalentInDollar - amountDue) * rate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            children: currencies.entries.map((entry) {
              String code = entry.key;
              String label = entry.value['label'];
              String flagPath = entry.value['flag'];
              double rate = entry.value['rate'];
              return _buildCurrencyBlock(code, label, flagPath, rate);
            }).toList(),
          ),
        ),
        const Divider(),
        _buildSummarySection(),
      ],
    );
  }

  Widget _buildCurrencyBlock(
      String code, String label, String flagPath, double rate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildFlagIcon(flagPath),
              const SizedBox(width: 8),
              Text('$label', style: const TextStyle(fontSize: 16)),
              Text(
                  ' - ${code == 'USD' ? '\$' : code == 'BRL' ? 'R\$' : 'Gs'} $rate'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildLabeledField(
                    'Valor', _buildValueInput(controllers[code]!)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLabeledField(
                    'Troco', _buildChangeInput(controllers[code]!)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLabeledField(
                  'Total em Dólar',
                  _buildCalculatedField(controllers[code]!, rate),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Troco sugerido: ${code == 'USD' ? '\$' : code == 'BRL' ? 'R\$' : 'Gs'} ${_calculateSuggestedChange(double.tryParse(controllers[code]?.text ?? '0') ?? 0, rate).toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.grey),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildLabeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget _buildValueInput(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
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

  Widget _buildChangeInput(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Digite o troco',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: currencies.entries.map((entry) {
          String code = entry.key;
          String label = entry.value['label'];
          double rate = entry.value['rate'];
          double amountSent =
              double.tryParse(controllers[code]?.text ?? '0') ?? 0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Valor enviado em $label',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${code == 'USD' ? '\$' : code == 'BRL' ? 'R\$' : 'Gs'} ${amountSent.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.green, fontSize: 14),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
