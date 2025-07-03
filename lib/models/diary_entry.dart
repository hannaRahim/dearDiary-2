class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final String mood;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.mood,
  });

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
      mood: map['mood'],
    );
  }
}
