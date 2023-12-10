import 'dart:math';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:textingcg/login_page.dart';
import 'package:textingcg/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 55,
                width: 55,
                color: Colors.yellow,
              ),
              Container(
                child: Text(
                  'Color Game Flutter',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ],
          ),
        ),
        nextScreen: LoginPage(),
        splashTransition: SplashTransition.decoratedBoxTransition,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}

class ColorMatchingGame extends StatefulWidget {
  @override
  _ColorMatchingGameState createState() => _ColorMatchingGameState();
}

class _ColorMatchingGameState extends State<ColorMatchingGame> {
  bool canProceed = true;
  List<Color> selectedColors = [];
  List<Color> options = [
    Colors.red.shade900,
    Colors.deepPurple.shade300,
    Color.fromARGB(255, 255, 238, 0),
    Color.fromARGB(255, 33, 29, 29),
    Colors.orange,
    const Color.fromARGB(255, 98, 176, 39),
  ];

  List<Color> randomColors = [];

  bool showOutcome = false;
  bool optionsClickable = true;
  bool resultShown = false;
  bool gameInProgress = true;
  int coins = 50;
  int betAmount = 0;
  bool betLocked =
      false; // New variable to track whether the bet amount is locked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/green.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Align the children to the start and end of the row
                      children: [
                        // Add the back button to the left side
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WelcomeScreen(),
                                ));
                          },
                          iconSize: 40.0,
                        ),

                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.info,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showInstructionGame(context);
                              },
                              iconSize: 40.0,
                            ),
                            Image.asset(
                              'assets/images/coin.png',
                              width: 40,
                              height: 40,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '$coins',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    if (showOutcome) ...[
                      _buildRandomColors(),
                      SizedBox(height: 20),
                      _buildOutcome(),
                      SizedBox(height: 20),
                    ],
                    SizedBox(
                      height: 10,
                    ),

                    _buildOptions(), // Call the _buildOptions() method

                    // BET BUTTON (SHOW RESULT) BUTTON FUNCTION
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedColors.isNotEmpty &&
                            !resultShown &&
                            gameInProgress &&
                            canProceed) {
                          checkOutcome();
                          setState(() {
                            resultShown = true;
                            gameInProgress = false;
                            betLocked = true; // Lock the bet amount
                          });
                        } else if (betAmount > coins) {
                          // Show an alert dialog for insufficient coins
                          _showInsufficientCoinsAlert();
                          setState(() {
                            canProceed = false; // Disable further actions
                          });
                        } else {
                          // If none of the conditions are met, do nothing
                          return;
                        }
                      },
                      child: Text('BET',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight
                                  .w900)), // Set the text color to black
                      style: ElevatedButton.styleFrom(
                          primary:
                              Colors.white, // Set the background color to white
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24)),
                    ),

                    //ROLL(RESTART) BUTTON FUNCTION
                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          // Inside the onPressed handler for the "Restart" button
                          onPressed: () {
                            if (coins == 0) {
                              _showZeroCoinsAlert();
                            } else {
                              setState(() {
                                selectedColors.clear();
                                showOutcome = false;
                                optionsClickable = true;
                                resultShown = false;
                                gameInProgress = true;
                                betLocked = false; // Unlock the bet amount
                                canProceed = true; // Allow further actions
                              });
                            }
                          },
                          child: Text(
                            'ROLL',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight
                                    .w900), // Set the text color to black
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors
                                  .white, // Set the background color to white
                              padding: EdgeInsets.symmetric(vertical: 16)),
                        ),

                        // BET AMOUNT
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'YOUR BET: ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 80,
                              child: TextField(
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                                enabled: coins > 0 &&
                                    !betLocked, // Disable if coins are 0 or bet is locked
                                onChanged: (value) {
                                  if (!betLocked && value.isNotEmpty) {
                                    int newBet = int.parse(value);
                                    setState(() {
                                      betAmount = min(max(newBet, 1), coins);
                                      canProceed = betAmount <=
                                          coins; // Check if the bet amount is less than or equal to available coins
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 30.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          Color color = options[index];
          return GestureDetector(
            onTap: () {
              if (optionsClickable && gameInProgress && betAmount <= coins) {
                setState(() {
                  if (selectedColors.contains(color)) {
                    selectedColors.remove(color);
                  } else {
                    selectedColors.add(color);
                  }
                  showOutcome = false;
                });
              }
            },
            child: Container(
              width: 20, // Adjust the width as needed
              height: 20, // Adjust the height as needed
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(15.0)),
              child: selectedColors.contains(color)
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                    )
                  : null,
            ),
          );
        });
  }

  void generateRandomColors() {
    randomColors = List.generate(3, (index) {
      return options[Random().nextInt(options.length)];
    });
  }

  void checkOutcome() {
    generateRandomColors();

    // Calculate won and lost coins for each selected color
    Map<Color, int> wonCoinsMap = {};
    Map<Color, int> lostCoinsMap = {};

    for (Color selectedColor in selectedColors) {
      int wonCoins = betAmount * (randomColors.contains(selectedColor) ? 1 : 0);
      int lostCoins = betAmount - wonCoins;

      wonCoinsMap[selectedColor] = wonCoins;
      lostCoinsMap[selectedColor] = lostCoins;
    }

    // Calculate the total won and lost coins
    int totalWonCoins = wonCoinsMap.values.reduce((a, b) => a + b);
    int totalLostCoins = lostCoinsMap.values.reduce((a, b) => a + b);

    // Check if the bet amount is greater than the available coins
    if (betAmount > coins) {
      _showInsufficientCoinsAlert();
      return;
    }

    setState(() {
      coins += totalWonCoins - totalLostCoins;
      coins = max(0, coins);
      showOutcome = true;
    });

    print(
        'coins: $coins, totalWonCoins: $totalWonCoins, totalLostCoins: $totalLostCoins');
  }

  String _calculateWinningAmount() {
    int totalWonCoins = 0;
    int totalLostCoins = 0;

    for (Color selectedColor in selectedColors) {
      if (randomColors.contains(selectedColor)) {
        totalWonCoins += betAmount;
      } else {
        totalLostCoins += betAmount;
      }
    }

    // Display separate messages for winning and losing amounts
    String winMessage = totalWonCoins > 0 ? 'You WON $totalWonCoins COINS' : '';
    String loseMessage =
        totalLostCoins > 0 ? ' but LOST $totalLostCoins COINS' : '';

    return '$winMessage$loseMessage';
  }

  Widget _buildRandomColors() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: randomColors
          .map(
            (color) => Container(
              width: 80,
              height: 80,
              color: color,
            ),
          )
          .toList(),
    );
  }

  Widget _buildOutcome() {
    return resultShown
        ? Column(
            children: [
              SizedBox(height: 10),
              Text(
                randomColors.any((color) => selectedColors.contains(color))
                    ? 'You Win! ${_calculateWinningAmount()}'
                    : 'You Lose! [-${betAmount * selectedColors.length}] Coins',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          )
        : Container();
  }

  Future<void> _showZeroCoinsAlert() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cannot Restart'),
          content: Text('Your coins are 0. You cannot restart the game.'),
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

  Future<void> _showInsufficientCoinsAlert() async {
    // Show the insufficient coins alert
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Insufficient Coins'),
          content: Text('You do not have enough coins to bet that amount.'),
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

    // Reset the game state if needed
    if (betAmount > coins) {
      setState(() {
        selectedColors.clear();
        showOutcome = false;
        optionsClickable = true;
        resultShown = false;
        gameInProgress = true;
        betLocked = false; // Unlock the bet amount
      });
    }
  }

  void showInstructionGame(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Game Instructions',
            style: TextStyle(
                fontSize: 40.0,
                color: Colors.amber.shade600,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            '[ROLL] Button - After Betting [BET] You will need to click this if you want to BET AGAIN\n'
            '\n[BET] Button - After Choosing a Colors and Decide how much coins you bet, you will click this to [BET] show result'
            '\n\n[YOUR BET] - Here you will actually enter how many you will be betting.'
            '\n\n\n\nThis Game was made by Wani Games'
            '\nWani Games is actually from my nickname Joanna!'
            '\n\n\n\n                             Also I made that Logo ~ '
            '\n                            Tehe! Happy Gambling!',
            style: TextStyle(fontSize: 16),
          ),
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
