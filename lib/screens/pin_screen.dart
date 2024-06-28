import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String pin = '';
  bool isPinSet = false; // Track if PIN is set

  @override
  void initState() {
    super.initState();
    _checkPinStatus(); // Check if PIN is already set
  }

  Future<void> _checkPinStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isPinSet = prefs.containsKey('pin');
    });
  }

  void _addNumber(String number) {
    if (pin.length < 4) {
      setState(() {
        pin += number;
        if (pin.length == 4) {
          if (isPinSet) {
            // Verify PIN when set
            _verifyPinAndNavigate();
          } else {
            // Save new PIN when not set
            _savePinAndNavigate();
          }
        }
      });
    }
  }

  void _removeNumber() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
      });
    }
  }

  void _savePinAndNavigate() async {
    // Save PIN using SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', pin);

    // Update isPinSet
    setState(() {
      isPinSet = true;
    });

    Navigator.pushReplacementNamed(context, '/home');
  }

  void _verifyPinAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedPin = prefs.getString('pin') ?? '';
    if (pin == storedPin) {
      // Correct PIN entered, navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Incorrect PIN entered, reset PIN entry
      setState(() {
        pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const double circleSize = 48.0; // Reduced circle size
    const double circleSpacing = 16.0; // Reduced spacing between circles
    const buttonSize = EdgeInsets.all(20.0);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 24.0),
            Text(
              isPinSet ? 'Enter PIN' : 'Set Your PIN',
              style: const TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 4; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: circleSpacing),
                            child: Container(
                              width: circleSize,
                              height: circleSize,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  i < pin.length ? '*' : '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 72.0),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        9,
                            (index) {
                          return Padding(
                            padding: buttonSize,
                            child: MaterialButton(
                              onPressed: () => _addNumber('${index + 1}'),
                              color: Theme.of(context).colorScheme.onPrimary,
                              textColor: Colors.black,
                              shape: const CircleBorder(), // Black text color
                              child: Text('${index + 1}', style: const TextStyle(fontSize: 24.0)),
                            ),
                          );
                        },
                      )..addAll([
                        const Padding(padding: buttonSize, child: Text('')),
                        Padding(
                          padding: buttonSize,
                          child: MaterialButton(
                            onPressed: () => _addNumber('0'),
                            color: Theme.of(context).colorScheme.onPrimary,
                            textColor: Colors.black,
                            shape: const CircleBorder(),
                            child: const Text('0', style: TextStyle(fontSize: 24.0)),
                          ),
                        ),
                        Padding(
                          padding: buttonSize,
                          child: MaterialButton(
                            onPressed: _removeNumber, // Remove last character
                            color: Theme.of(context).colorScheme.onPrimary,
                            textColor: Colors.black,
                            shape: const CircleBorder(), // Black text color
                            child: const Icon(Icons.backspace_outlined, size: 24.0),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
