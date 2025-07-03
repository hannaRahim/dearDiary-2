import 'package:flutter/material.dart';
import 'write_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> hashtags = [
    '#grateful',
    '#school',
    '#friends',
    '#family',
    '#goals',
    '#travel',
  ];

  double _moodValue = 0.5;
  String? selectedTag;

  String getMoodLabel(double value) {
    if (value < 0.25) return 'Sad';
    if (value < 0.6) return 'Neutral';
    return 'Happy';
  }

  String getEmoji(double value) {
    if (value < 0.25) return '😔';
    if (value < 0.6) return '😐';
    return '😊';
  }

  void _navigateToWritePage() {
    final mood = getMoodLabel(_moodValue);
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => WritePage(mood: mood),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final moodEmoji = getEmoji(_moodValue);
    final moodLabel = getMoodLabel(_moodValue);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('DearDiary'),
        backgroundColor: const Color(0xFF2C2C3A),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        onPressed: _navigateToWritePage,
        child: const Icon(Icons.add),
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

              // 😄 Mood Slider + Emoji
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      moodEmoji,
                      style: const TextStyle(fontSize: 60),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      moodLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    Slider(
                      value: _moodValue,
                      onChanged: (value) {
                        setState(() => _moodValue = value);
                      },
                      min: 0.0,
                      max: 1.0,
                      divisions: 4,
                      activeColor: Colors.pinkAccent,
                      inactiveColor: Colors.grey,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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
                          color: isSelected ? Colors.pinkAccent : Colors.grey[700],
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

              // 📝 Placeholder for filtered entries
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  selectedTag != null
                      ? 'Showing entries for $selectedTag'
                      : 'Select a tag to filter your entries',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
