import 'package:flutter/material.dart';
import 'package:fp_games/model/user_model.dart';
import 'package:fp_games/routes/router_name.dart';
import 'package:fp_games/service/user_database_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String error = "";

  late UserModel _currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Register',
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
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm Password',
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Login'),
                ),
              ],
            ),
            Text(
              error,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 5),
            _registerButton(),
          ],
        ),
      ),
    ));
  }

  Widget _registerButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_usernameController.text.isEmpty ||
            _emailController.text.isEmpty ||
            _passwordController.text.isEmpty ||
            _confirmPasswordController.text.isEmpty) {
          setState(() {
            error = "Please fill all the fields";
          });
          return;
        }

        if (_confirmPasswordController.text != _passwordController.text) {
          setState(() {
            error = "Password and Confirm Password must be the same";
          });
          return;
        }
        UserModel user = UserModel(
            username: _usernameController.text,
            email: _emailController.text,
            password: _passwordController.text);
        try {
          await userDatabaseHelper.createUser(user);
        } catch (e) {
          setState(() {
            error = e.toString();
          });
          return;
        }
        final snackBar = SnackBar(content: Text('Register Success!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pushReplacementNamed(context, RouterName.login);
      },
      child: Text('Register'),
    );
  }
}
