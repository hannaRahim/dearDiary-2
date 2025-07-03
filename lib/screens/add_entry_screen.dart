import 'package:flutter/material.dart';

class AddEntryScreen extends StatelessWidget {
  const AddEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            TextField(decoration: InputDecoration(labelText: 'Title')),
            TextField(
              decoration: InputDecoration(labelText: 'What happened today?'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            Text('Mood: 😀 😐 😢'),
            Spacer(),
            ElevatedButton(onPressed: null, child: Text('Save Entry')),
          ],
        ),
      ),
    );
  }
}
