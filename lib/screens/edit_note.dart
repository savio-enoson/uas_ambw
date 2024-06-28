import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../classes/note.dart';

class EditNoteScreen extends StatefulWidget {
  final int noteId; // Changed to noteId

  const EditNoteScreen({super.key, required this.noteId});

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _textController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(); // Initialize the controllers
    _textController = TextEditingController();

    _loadNote();
  }

  Future<void> _loadNote() async {
    final Box<Note> notesBox = Hive.box<Note>('notesBox');
    final Note note = notesBox.values.firstWhere((note) => note.id == widget.noteId); // Find note by id

    _titleController.text = note.title; // Set text after initializing controller
    _textController.text = note.text;

    setState(() {
      _isLoading = false; // Set isLoading to false after loading note
    });
  }

  void _saveNote() {
    final Box<Note> notesBox = Hive.box<Note>('notesBox');
    final Note note = notesBox.values.firstWhere((note) => note.id == widget.noteId); // Find note by id

    note.title = _titleController.text;
    note.text = _textController.text;
    note.lastModified = DateTime.now();

    notesBox.put(note.key, note); // Use key instead of index

    Navigator.of(context).pop(); // Go back to previous screen
    }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(
            'Edit ${_titleController.text}',
            style: const TextStyle(
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
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              maxLines: null, // Allow multiple lines for text input
              decoration: const InputDecoration(labelText: 'Text'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green,
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

