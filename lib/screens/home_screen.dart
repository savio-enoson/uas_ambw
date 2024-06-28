import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../classes/note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Note> notesBox;

  // List of pastel colors for note backgrounds
  final List<Color> noteColors = [
    Colors.red[100]!,
    Colors.yellow[100]!,
    Colors.green[100]!,
    Colors.blue[100]!,
    Colors.pink[100]!,
    Colors.orange[100]!,
    Colors.purple[100]!,
    Colors.cyan[100]!,
  ];

  @override
  void initState() {
    super.initState();
    notesBox = Hive.box<Note>('notesBox');
  }

  Future<void> _deleteNoteById(int id) async {
    final noteToDelete = notesBox.values.firstWhere(
          (note) => note.id == id,
      orElse: () => Note.empty(), // Return a dummy Note object or handle appropriately
    );

    if (noteToDelete != Note.empty()) {
      // Show confirmation dialog
      bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Confirm Delete"),
            content: const Text("Are you sure you want to delete this note?"),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );

      // Delete note if confirmed
      if (confirmDelete ?? false) {
        setState(() {
          notesBox.delete(noteToDelete.key); // Delete note by its key
        });
      }
    } else {
      // Handle case where note with the specified id is not found
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Note Not Found"),
            content: const Text("The note you are trying to delete does not exist."),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text(
            'Homepage',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: notesBox.listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No notes available.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final note = box.getAt(index) as Note;
              final color = noteColors[index % noteColors.length];

              return note.build(
                context,
                color,
                    () => _deleteNoteById(note.id), // Pass id to delete method
              );
            },
          );
        },
      ),
    );
  }
}
