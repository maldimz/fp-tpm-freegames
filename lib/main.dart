import 'package:flutter/material.dart';
import 'package:fp_games/pages/home_page.dart';
import 'package:fp_games/pages/login_page.dart';
import 'package:fp_games/routes/router_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getInt('userId');
  print(userId);
  runApp(MaterialApp(
    title: 'Final Project',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: userId == null ? LoginPage() : HomePage(),
    onGenerateRoute: RouterGenerator.generateRoute,
  ));
}
