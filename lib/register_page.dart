import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _passwordErrorText = '';
  bool _submitted = false;

  // Store registered credentials

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Register'),
      ),
      body: Container(
        color: Colors.grey.shade300,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              height: 100, // Adjust the height of the logo
              child: Image.asset(
                'assets/images/JoannaLogo.png', // Adjust the path based on your asset location
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
                height:
                    16), // Adjust the spacing between the logo and the text field
            TextField(
              controller: _usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                errorText: _submitted ? _passwordErrorText : null,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Mark form as submitted
                setState(() {
                  _submitted = true;
                });

                // Simulate a simple registration condition
                String username = _usernameController.text.trim();
                String password = _passwordController.text.trim();

                // Reset error text
                setState(() {
                  _passwordErrorText = '';
                });

                if (password.isNotEmpty) {
                  // Check for at least one special symbol and numbers
                  if (!RegExp(r'[@#$%^&*()_+{}\[\]:;<>,.?~\\-]')
                          .hasMatch(password) ||
                      !RegExp(r'[0-9]').hasMatch(password)) {
                    setState(() {
                      _passwordErrorText =
                          'Password must have at least one special symbol and numbers.';
                    });
                  } else {
                    // Store registered credentials

                    // Registration successful (You can add your registration logic here)
                    // For now, just print a success message
                    print('Registration successful');

                    // Navigate back to the login page with prefilled values
                    Navigator.pop(
                        context, {'username': username, 'password': password});
                  }
                } else {
                  // Show an error message for empty password field
                  setState(() {
                    _passwordErrorText = 'Please enter a password.';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                shadowColor: Colors.greenAccent,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
