import 'package:flutter/material.dart';
import 'package:deardiary2/services/supabase_services.dart';
import 'package:deardiary2/screens/login_screen.dart'; // Import LoginScreen for logout navigation
import 'add_entry_screen.dart'; // Import AddEntryScreen
import 'package:deardiary2/models/diary_entry.dart'; // Import DiaryEntry

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<String> hashtags = [
    '#grateful',
    '#school',
    '#friends',
    '#family',
    '#goals',
    '#travel',
  ];

  final List<Map<String, String>> moods = [
    {'emoji': '😄', 'label': 'Happy'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '😢', 'label': 'Sad'},
    {'emoji': '😡', 'label': 'Angry'},
    {'emoji': '😨', 'label': 'Anxious'},
    {'emoji': '😴', 'label': 'Tired'},
    {'emoji': '🤩', 'label': 'Excited'},
  ];

  String? selectedTag;
  String? selectedMood;
  List<DiaryEntry> _diaryEntries = [];
  final SupabaseService _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    try {
      final entries = await _supabaseService.getEntries();
      setState(() {
        _diaryEntries = entries;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load entries: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _navigateToaddEntryScreen(String mood) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => AddEntryScreen(mood: mood), // Navigate to AddEntryScreen
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ).then((_) {
      // Refresh entries when returning from AddEntryScreen
      _fetchEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('DearDiary'),
        backgroundColor: const Color(0xFF2C2C3A),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _supabaseService.signOut();
              // Navigate back to login screen or splash screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()), // Assuming LoginScreen is your initial auth screen
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👋 Greeting
              const Text(
                'Hello 👋\nHow are you feeling today?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // 🎭 Mood Selector
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: moods.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final mood = moods[index];
                    final isSelected = selectedMood == mood['label'];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedMood = mood['label'];
                        });
                        Future.delayed(const Duration(milliseconds: 150), () {
                          _navigateToaddEntryScreen(selectedMood!); // Call the updated navigation
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        width: isSelected ? 100 : 90,
                        height: isSelected ? 100 : 90,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: isSelected
                                ? [Colors.pinkAccent, Colors.purpleAccent]
                                : [Colors.grey.shade800, Colors.grey.shade700],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.pinkAccent.withOpacity(0.4),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              mood['emoji']!,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mood['label']!,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // 🏷 Hashtag Filter
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Browse by Tags:',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: hashtags.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final tag = hashtags[index];
                    final isSelected = tag == selectedTag;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTag = isSelected ? null : tag;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.pinkAccent
                              : Colors.grey[700],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          tag,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Display filtered entries
              _diaryEntries.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        selectedTag != null
                            ? 'No entries found for $selectedTag'
                            : 'No entries yet. Start writing!',
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _diaryEntries.length,
                      itemBuilder: (context, index) {
                        final entry = _diaryEntries[index];
                        // Filter by selectedTag if it's not null
                        if (selectedTag != null && !entry.content.toLowerCase().contains(selectedTag!.substring(1).toLowerCase()) && !entry.title.toLowerCase().contains(selectedTag!.substring(1).toLowerCase())) {
                          return const SizedBox.shrink(); // Hide if not matching tag
                        }
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  entry.content,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Mood: ${entry.mood}',
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '${entry.createdAt.day}/${entry.createdAt.month}/${entry.createdAt.year}',
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
