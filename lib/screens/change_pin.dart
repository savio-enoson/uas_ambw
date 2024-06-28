import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  _ChangePinScreenState createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  bool _obscurePin = true; // Initially obscure PIN

  String _currentPin = ''; // Placeholder for current PIN from SharedPreferences

  @override
  void initState() {
    super.initState();
    // Load current PIN from SharedPreferences (replace with your actual logic)
    _loadCurrentPin();
  }

  Future<void> _loadCurrentPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentPin = prefs.getString('pin') ?? ''; // Default to empty string if not found
    });
  }

  void _togglePinVisibility() {
    setState(() {
      _obscurePin = !_obscurePin;
    });
  }

  void _showResetPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Reset PIN?'),
          content: const Text('This will reset your current PIN. Continue?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                _resetPin();
                Navigator.of(context).pop();
              },
              child: const Text('Reset', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _resetPin() async {
    // Reset PIN logic (example clears SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('pin');
    setState(() {
      _currentPin = '';
    });

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text(
            'PIN',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Label for current PIN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: <Widget>[
                  const Text('Current PIN:     ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter PIN',
                      ),
                      readOnly: true,
                      obscureText: _obscurePin,
                      controller: TextEditingController(text: _currentPin),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_obscurePin ? Icons.visibility : Icons.visibility_off),
                    onPressed: _togglePinVisibility,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            // Button to reset PIN
            ElevatedButton(
              onPressed: () {
                _showResetPinDialog(context);
              },
              child: const Text('Change Pin'),
            ),
          ],
        ),
      ),
    );
  }
}
