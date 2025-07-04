import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:deardiary2/models/diary_entry.dart'; // Import the DiaryEntry model

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user ID
  String? get currentUserId => _supabase.auth.currentUser?.id;

  // Add a new diary entry
  Future<void> addEntry(DiaryEntry entry) async {
    try {
      await _supabase.from('diary_entries').insert(entry.toMap());
    } catch (e) {
      print('Error adding entry: $e');
      rethrow;
    }
  }

  // Fetch diary entries for the current user
  Future<List<DiaryEntry>> getEntries() async {
    try {
      // Ensure user is logged in before fetching
      if (currentUserId == null) {
        throw Exception('User not authenticated.');
      }
      final response = await _supabase
          .from('diary_entries')
          .select()
          .eq('user_id', currentUserId!) // Filter by current user
          .order('created_at', ascending: false); // Order by date

      final List<dynamic> data = response as List<dynamic>;
      return data.map((map) => DiaryEntry.fromMap(map)).toList();
    } catch (e) {
      print('Error fetching entries: $e');
      rethrow;
    }
  }

  // User Sign Up
  Future<AuthResponse> signUp(String email, String password) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  // User Sign In
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  // User Sign Out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
}
