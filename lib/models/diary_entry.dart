class DiaryEntry {
  final String id;
  final String userId;
  final String title;
  final String content;
  final String mood;
  final List<String> tags;
  final List<String> imageUrls;
  final DateTime createdAt;


  DiaryEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.mood,
    required this.createdAt,
    required this.tags,
    required this.imageUrls,
  });

  // Factory constructor to create a DiaryEntry from a Supabase row
  factory DiaryEntry.fromMap(Map<String, dynamic> map) => DiaryEntry(
        id: map['id'],
        userId: map['user_id'],
        title: map['title'],
        content: map['content'],
        mood: map['mood'],
        tags: List<String>.from(map['tags'] ?? []),
        imageUrls: List<String>.from(map['image_urls'] ?? []),
        createdAt: DateTime.parse(map['created_at']),
  );

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
