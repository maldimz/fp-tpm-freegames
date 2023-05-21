import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fp_games/service/rates_api.dart';
import 'package:intl/intl.dart';

class UpgradePage extends StatefulWidget {
  const UpgradePage({Key? key}) : super(key: key);

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  late PageController _pageController;
  final List<int> price = [50000, 150000, 250000];
  final _numberFormat = NumberFormat("#,##0.00");
  int _selectedIndex = 0;
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
    _pageController = PageController(viewportFraction: 0.9);
  }

  String _formatRuipah(int value) {
    return "Rp ${_numberFormat.format(value)}";
  }

  String _formatTwoDecimal(double value) {
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Upgrade Plan"),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: EdgeInsets.only(top: 20),
                    child: PageView(
                        physics: BouncingScrollPhysics(),
                        pageSnapping: true,
                        controller: _pageController,
                        onPageChanged: (value) {
                          setState(() {
                            _selectedIndex = value;
                          });
                        },
                        children: [
                          _planStandart(),
                          _planPlus(),
                          _planPro(),
                        ]),
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Money converter',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Card(
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/us.png',
                              width: 50,
                            ),
                            title: Text('USD'),
                            subtitle: Text(_rates['USD'] != null
                                ? '\$${_formatTwoDecimal(_rates['USD'] * price[_selectedIndex])}'
                                : ''),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/europe.png',
                              width: 50,
                            ),
                            title: Text('EUR'),
                            subtitle: Text(_rates['EUR'] != null
                                ? '€${_formatTwoDecimal(_rates['EUR'] * price[_selectedIndex])}'
                                : ''),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/london.png',
                              width: 50,
                            ),
                            title: Text('GBP'),
                            subtitle: Text(_rates['GBP'] != null
                                ? '£${_formatTwoDecimal(_rates['GBP'] * price[_selectedIndex])}'
                                : ''),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/japan.png',
                              width: 50,
                            ),
                            title: Text('JPY'),
                            subtitle: Text(_rates['JPY'] != null
                                ? '¥${_formatTwoDecimal(_rates['JPY'] * price[_selectedIndex])}'
                                : ''),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Image.asset(
                              'assets/images/malaysia.png',
                              width: 50,
                            ),
                            title: Text('MYR'),
                            subtitle: Text(_rates['MYR'] != null
                                ? 'RM${_formatTwoDecimal(_rates['MYR'] * price[_selectedIndex])}'
                                : ''),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Card _planStandart() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Text("Standart",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text("Price: ${_formatRuipah(price[0])}",
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Text("Get access to all features"),
                  SizedBox(height: 20),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check),
                            SizedBox(width: 5),
                            Text("Unlimited access to all games")
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  final snackBar = SnackBar(
                    content: Text("Feature Maintenance"),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text("Get Started")),
          ],
        ),
      ),
    );
  }

  Card _planPlus() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Text("Plus",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text("Price: ${_formatRuipah(price[1])}",
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Text("Get access to all features"),
                  SizedBox(height: 20),
                  Container(
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  final snackBar = SnackBar(
                    content: Text("Feature Maintenance"),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text("Get Started")),
          ],
        ),
      ),
    );
  }

  Card _planPro() {
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Text("Pro",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text("Price: ${_formatRuipah(price[2])}",
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  Text("Get access to all features"),
                  SizedBox(height: 20),
                  Container(
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
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  final snackBar = SnackBar(
                    content: Text("Feature Maintenance"),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text("Get Started")),
          ],
        ),
      ),
    );
  }
}
