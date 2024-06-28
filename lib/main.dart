import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'classes/note.dart';
import 'screens/home_screen.dart';
import 'screens/new_note_screen.dart';
import 'screens/change_pin.dart';
import 'screens/pin_screen.dart';

// Savio Enoson C14210278 | AMBW A

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  var box = await Hive.openBox<Note>('notesBox');
  // await box.clear();
  // SharedPreferences preferences = await SharedPreferences.getInstance();
  // await preferences.clear();
  if (box.isEmpty) {
    await createSampleNotes(box);
  }

  runApp(const MyApp());
}

Future<void> createSampleNotes(Box<Note> box) async {
  final random = Random();
  const loremText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';

  final startDate = DateTime(2024, 6, 15, 7, 0);
  final endDate = DateTime(2024, 6, 20, 14, 0);

  for (int i = 1; i <= 5; i++) {
    final randomCreatedDate = startDate.add(Duration(
      hours: random.nextInt(endDate.difference(startDate).inHours),
    ));
    final randomModifiedDate = randomCreatedDate.add(Duration(
      hours: random.nextInt(endDate.difference(randomCreatedDate).inHours),
    ));

    final note = Note(
      title: 'Note $i',
      text: loremText,
      created: randomCreatedDate,
      lastModified: randomModifiedDate,
      id: Hive.box<Note>('notesBox').length, // Assign a unique id to each note
    );

    await box.add(note);
  }
}

class MyApp extends StatelessWidget {
  static const Color default_background = Colors.white;
  static const Color border_color = Colors.white60;
  static const TextStyle h1 = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0);
  static const TextStyle h2 = TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0);
  static const TextStyle h3 = TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0);
  static const default_padding = EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generic Note App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColorLight: default_background,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          brightness: Brightness.light,
        ).copyWith(
          onPrimary: Colors.white,
        ),
      ),
      initialRoute: '/', // Set initial route to '/'
      routes: {
        '/': (context) => const PinScreen(), // Route '/' leads to PinScreen
        '/home': (context) => const NavigationBar(), // New route '/home' leads to NavigationBar
        '/new_note': (context) => const NewNoteScreen(),
        '/change_pin': (context) => const ChangePinScreen(),
      },
    );
  }
}

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  int _selectedIndex = 1; // Set initial index to 1 for 'Home'

  static final List<Widget> _widgetOptions = <Widget>[
    const NewNoteScreen(),
    const HomeScreen(),
    const ChangePinScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.note_add),
            label: 'New Note',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: 'Change PIN',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
