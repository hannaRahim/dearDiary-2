import 'package:flutter/material.dart';
import 'package:deardiary2/services/supabase_services.dart';
import 'package:deardiary2/screens/login_screen.dart';
import 'add_entry_screen.dart';
import 'package:deardiary2/models/diary_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String username = "Suhana"; // Dynamic if you want
  final List<String> hashtags = [
    '#grateful',
    '#school',
    '#friends',
    '#family',
    '#goals',
    '#travel',
  ];

  final List<Map<String, String>> moods = [
    {'image': 'imgHappy.png', 'label': 'Happy'},
    {'image': 'imgNeutral.png', 'label': 'Neutral'},
    {'image': 'imgSad.png', 'label': 'Sad'},
    {'image': 'imgAngry.png', 'label': 'Angry'},
    {'image': 'imgAnxious.png', 'label': 'Anxious'},
    {'image': 'imgTired.png', 'label': 'Tired'},
    {'image': 'imgExcited.png', 'label': 'Excited'},
    {'image': 'imgCustom.png', 'label': 'Custom'}, // Custom mood
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
        pageBuilder: (_, __, ___) => AddEntryScreen(mood: mood),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    ).then((_) {
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
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
              // Greeting
              Text(
                'Hello, $username 👋\nHow are you feeling today?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // Mood Selector
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: moods.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final mood = moods[index];
                    final isSelected = selectedMood == mood['label'];
                    final isCustom = mood['label'] == 'Custom';

                    return GestureDetector(
                      onTap: () {
                        final label = mood['label']!;
                        if (isCustom) {
                          _navigateToaddEntryScreen('');
                        } else {
                          setState(() {
                            selectedMood = label;
                          });
                          Future.delayed(const Duration(milliseconds: 150), () {
                            _navigateToaddEntryScreen(selectedMood!);
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
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
                            isCustom
                                ? const Icon(Icons.add, color: Colors.white, size: 32)
                                : Image.asset(
                                    'assets/images/${mood['image']}',
                                    width: 40,
                                    height: 40,
                                  ),
                            const SizedBox(height: 8),
                            Text(
                              mood['label']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Hashtag Filter
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

              // Recent Entries Label
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Recent Entries',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Entries Display
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
                        if (selectedTag != null &&
                            !entry.content.toLowerCase().contains(selectedTag!.substring(1).toLowerCase()) &&
                            !entry.title.toLowerCase().contains(selectedTag!.substring(1).toLowerCase())) {
                          return const SizedBox.shrink();
                        }

                        return Dismissible(
                          key: Key(entry.id.toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Entry'),
                                content: const Text('Are you sure you want to delete this entry?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          onDismissed: (direction) async {
                            await _supabaseService.deleteEntry(int.parse(entry.id!));
                            _fetchEntries();
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Card(
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
