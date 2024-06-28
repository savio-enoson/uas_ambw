import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../classes/note.dart';

class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({super.key});

  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _addNote(BuildContext context) {
    final String title = _titleController.text;
    final String text = _textController.text;
    final DateTime now = DateTime.now();

    // Validate title and text if necessary
    if (title.isNotEmpty && text.isNotEmpty) {
      final newNote = Note(
        title: title,
        text: text,
        created: now,
        lastModified: now,
        id: Hive.box<Note>('notesBox').length, // Assign a unique id
      );

      // Add new note to Hive box
      Hive.box<Note>('notesBox').add(newNote);

      // Navigate back to home screen and remove all routes below it
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show a snackbar or dialog to indicate required fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter title and text for the note.'),
          duration: Duration(seconds: 2),
        ),
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
            'New Note',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
              ),
              onPressed: () => _addNote(context),
              child: const Text('Add Note'),
            ),
          ],
        ),
      ),
    );
  }
}
