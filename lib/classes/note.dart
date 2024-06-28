import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive Flutter package for initialization
import '../screens/edit_note.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String text;

  @HiveField(2)
  DateTime created;

  @HiveField(3)
  DateTime lastModified;

  @HiveField(4)
  int id;

  Note({
    required this.title,
    required this.text,
    required this.created,
    required this.lastModified,
    required this.id, // Ensure id is required
  });

  // Static method to return an empty Note object
  static Note empty() {
    return Note(
      title: '',
      text: '',
      created: DateTime.now(),
      lastModified: DateTime.now(),
      id: -1, // Use a default id or any identifier that denotes it's empty
    );
  }

  void edit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(noteId: id),
      ),
    );
  }

  Widget build(BuildContext context, Color color, VoidCallback onDelete) {
    final dateFormat = DateFormat('MMM d yyyy, h:mma');
    return Container(
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(8), // Add some padding for better appearance
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero, // Remove padding inside the IconButton
                      iconSize: 20, // Make the icon smaller
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => edit(context),
                    ),
                  ),
                  const SizedBox(width: 8), // Add space between the icons
                  Container(
                    width: 32, // Adjust the width and height to make the white circle smaller
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero, // Remove padding inside the IconButton
                      iconSize: 20, // Make the icon smaller
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.black), // Add a horizontal rule below the title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8), // Add margin to the top and bottom of the text
            child: Text(text),
          ),
          const SizedBox(height: 8), // Add margin between the text and timestamps
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Created: ${dateFormat.format(created)}',
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),
                Text(
                  'Last Modified: ${dateFormat.format(lastModified)}',
                  style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}