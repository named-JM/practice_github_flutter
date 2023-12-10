import 'package:flutter/material.dart';
import 'package:textingcg/register_page.dart';
import 'package:textingcg/welcome_screen.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _usernameErrorText = '';
  String _passwordErrorText = '';
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade300,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/JoannaLogo.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TextField(
              controller: _usernameController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _submitted && _usernameErrorText.isNotEmpty
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
                errorText: _submitted ? _usernameErrorText : null,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(fontSize: 16),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _submitted && _passwordErrorText.isNotEmpty
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
                errorText: _submitted ? _passwordErrorText : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _submitted = true;
                });

                String registeredUsername = 'joanna';
                String registeredPassword = '1234joanna';

                String username = _usernameController.text.trim();
                String password = _passwordController.text.trim();

                setState(() {
                  _usernameErrorText = '';
                  _passwordErrorText = '';
                });

                if (username.isNotEmpty && password.isNotEmpty) {
                  if (username == registeredUsername &&
                      password == registeredPassword) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    );
                  } else {
                    if (username != registeredUsername) {
                      setState(() {
                        _usernameErrorText = 'Invalid username.';
                      });
                    }
                    if (password != registeredPassword) {
                      setState(() {
                        _passwordErrorText = _usernameErrorText.isEmpty
                            ? 'Invalid password.'
                            : '';
                      });
                    }

                    _showErrorDialog(context, 'Invalid username or password.');
                  }
                } else {
                  setState(() {
                    _usernameErrorText =
                        username.isEmpty ? 'Please enter your email.' : '';
                    _passwordErrorText =
                        password.isEmpty ? 'Please enter your password.' : '';
                  });
                  _showErrorDialog(
                    context,
                    'Please fill in both fields.',
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shadowColor: Color.fromARGB(255, 0, 0, 0),
                elevation:
                    10, // Increase the elevation for a stronger glow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('Login'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.black,
                elevation: 5,
                primary: Colors.green,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                side: BorderSide(color: Colors.green),
              ),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Authentication Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
