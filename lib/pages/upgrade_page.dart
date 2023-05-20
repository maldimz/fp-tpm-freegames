import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fp_games/service/rates_api.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({Key? key}) : super(key: key);

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  final price = 250000;
  Map<String, dynamic> _rates = {};

  Future<void> _getRates() async {
    var rates = await RatesApi().fetchRates();

    setState(() {
      _rates = rates;
    });
  }

  @override
  void initState() {
    super.initState();
    _getRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upgrade Plan"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Pro",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text("Price: Rp 250.000,00", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Text("Get access to all features"),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 5),
                        Text("Unlimited access to all games")
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 5),
                        Text("Unlimited access to all reviews")
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 5),
                        Text("Unlimited access to all articles")
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 5),
                        Text("Get update on new games")
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    final snackBar = SnackBar(
                      content: Text("Feature Maintenance"),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Text("Get Started")),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 20),
              Text('Money converter',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(_rates['USD'] != null
                  ? 'USD: \$${_rates['USD'] * price}'
                  : ''),
              SizedBox(height: 10),
              Text(_rates['EUR'] != null
                  ? 'EUR: €${_rates['EUR'] * price}'
                  : ''),
              SizedBox(height: 10),
              Text(_rates['GBP'] != null
                  ? 'GBP: £${_rates['GBP'] * price}'
                  : ''),
            ],
          ),
        ),
      ),
    );
  }
}
