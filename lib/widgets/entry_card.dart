import 'package:flutter/material.dart';

class EntryCard extends StatelessWidget {
  final String title;
  final String date;
  final String mood;

  const EntryCard({super.key, required this.title, required this.date, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(date),
        trailing: Text(mood),
      ),
    );
  }
}
