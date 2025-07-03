import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dummy data — replace with Supabase values later
  final int totalEntries = 12;
  final int streakCount = 4;
  final int photoCount = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2C2C3A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.png'), // Replace with user image
            ),
            const SizedBox(height: 12),
            Text(
              'Entries Made: $totalEntries',
              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),

            // My Records
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Records ✨',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _RecordCard(
                  label: 'Streak',
                  count: streakCount,
                  icon: Icons.bolt_rounded,
                  onTap: () {},
                ),
                _RecordCard(
                  label: 'Photos',
                  count: photoCount,
                  icon: Icons.photo_library,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 32),

            // App Info
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'App Info',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.pinkAccent),
              title: const Text('App Version', style: TextStyle(color: Colors.white)),
              subtitle: const Text('DearDiary v1.0.0', style: TextStyle(color: Colors.white70)),
            ),
            ListTile(
              leading: const Icon(Icons.feedback_outlined, color: Colors.pinkAccent),
              title: const Text('Send Feedback', style: TextStyle(color: Colors.white)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: const Color(0xFF2C2C3A),
                    title: const Text('Feedback', style: TextStyle(color: Colors.white)),
                    content: const Text('Coming soon!', style: TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final VoidCallback onTap;

  const _RecordCard({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.pink.shade100.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.pinkAccent, width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.pinkAccent),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
