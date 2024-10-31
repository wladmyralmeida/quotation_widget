import 'package:flutter/material.dart';

class PaymentByCash extends StatefulWidget {
  final ValueChanged<double> onTotalChange;
  final ValueChanged<double> onTotalChangeForChange;

  const PaymentByCash({
    super.key,
    required this.onTotalChange,
    required this.onTotalChangeForChange,
  });

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
  final Map<String, TextEditingController> changeControllers = {};
  double amountDue = 100.0; // Valor total a ser pago

  @override
  void initState() {
    super.initState();
    // Criando controladores independentes para cada campo de valor e troco
    currencies.forEach((key, _) {
      controllers[key] = TextEditingController();
      changeControllers[key] = TextEditingController();
    });
  }

  @override
  void dispose() {
    // Garantindo que cada controlador seja descartado corretamente
    controllers.forEach((_, controller) => controller.dispose());
    changeControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void _calculateTotals() {
    double totalPaid = 0.0;
    double totalChange = 0.0;
    currencies.forEach((key, value) {
      double rate = value['rate'];
      double amountSent = double.tryParse(controllers[key]?.text ?? '0') ?? 0;
      double changeGiven =
          double.tryParse(changeControllers[key]?.text ?? '0') ?? 0;

      // Total pago em dólar
      totalPaid += amountSent / rate;
      // Troco total dado
      totalChange += changeGiven / rate;
    });

    widget.onTotalChange(totalPaid);
    widget.onTotalChangeForChange(totalChange);
  }

  double _calculateSuggestedChange(String code) {
    double rate = currencies[code]['rate'];
    double amountSent = double.tryParse(controllers[code]?.text ?? '0') ?? 0;
    double amountChangeReceived =
        double.tryParse(changeControllers[code]?.text ?? '0') ?? 0;
    double equivalentInDollar = (amountSent - amountChangeReceived) / rate;
    return (equivalentInDollar - amountDue) * rate;
  }

  double _calculateTotalInDollar(String code) {
    double rate = currencies[code]['rate'];
    double amount = double.tryParse(controllers[code]?.text ?? '0') ?? 0;
    return amount / rate;
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
                    'Troco', _buildChangeInput(changeControllers[code]!)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildLabeledField(
                  'Total em Dólar',
                  Text(
                    '\$${_calculateTotalInDollar(code).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Troco sugerido: ${code == 'USD' ? '\$' : code == 'BRL' ? 'R\$' : 'Gs'} ${_calculateSuggestedChange(code).toStringAsFixed(2)}',
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
      onChanged: (value) => _calculateTotals(),
    );
  }

  Widget _buildChangeInput(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) => _calculateTotals(),
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
