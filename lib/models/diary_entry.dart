class DiaryEntry {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String mood;
  final DateTime createdAt;

  DiaryEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.mood,
    required this.createdAt,
  });

  // Factory constructor to create a DiaryEntry from a Supabase row
  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      mood: map['mood'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // Convert DiaryEntry to a map for Supabase insertion
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'content': content,
      'mood': mood,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
