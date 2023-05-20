import 'package:flutter/material.dart';
import 'package:fp_games/model/user_model.dart';
import 'package:fp_games/routes/router_name.dart';
import 'package:fp_games/service/user_database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        error = "";
                      });
                      Navigator.pushNamed(context, RouterName.register);
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 5),
              ElevatedButton(
                onPressed: () async {
                  try {
                    var listUser =
                        await userDatabaseHelper.getUserByUsernameAndPassword(
                            _usernameController.text, _passwordController.text);
                    if (listUser.length > 0) {
                      final snackbar = SnackBar(
                        content: Text('Login Success'),
                      );
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString('username', listUser[0].username!);
                      pref.setInt('userId', listUser[0].id!);
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Navigator.pushReplacementNamed(
                          context, RouterName.homepage);
                    }
                  } catch (e) {
                    setState(() {
                      error = 'Username or Password is wrong';
                    });
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
