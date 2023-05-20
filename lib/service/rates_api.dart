import 'dart:convert';

import 'package:http/http.dart' as http;

class RatesApi {
  Future<Map<String, dynamic>> fetchRates() async {
    var url = Uri.parse('https://api.exchangerate.host/latest?base=IDR');
    var response = await http.get(url);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    Map<String, dynamic> rates = {};
    if (data != null) {
      rates = data['rates'].cast<String, dynamic>();
    }

    return rates;
  }
}
