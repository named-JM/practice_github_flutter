import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textingcg/main.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/casino-white.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ColorMatchingGame(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/play.png', // Replace with your button image
                  width: 200, // Set the width as needed
                  height: 200, // Set the height as needed
                ),
              ),
              InkWell(
                onTap: () {
                  // Exit the app
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                },
                child: Image.asset(
                  'assets/images/exit.png', // Replace with your button image
                  width: 150, // Set the width as needed
                  height: 150, // Set the height as needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
