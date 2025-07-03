import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<String>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 🧪 Mocked diary entries (you can later fetch from Supabase)
  final Map<DateTime, List<String>> _mockDiaryEntries = {
    DateTime.utc(2025, 7, 2): ['Feeling productive 😄'],
    DateTime.utc(2025, 7, 3): ['Wrote a new diary entry 📖'],
    DateTime.utc(2025, 7, 6): ['Tired but happy 😴'],
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  List<String> _getEventsForDay(DateTime day) {
    return _mockDiaryEntries[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Calendar'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2C2C3A),
      ),
      body: Column(
        children: [
          TableCalendar<String>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _selectedEvents.value = _getEventsForDay(selectedDay);
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.pinkAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.purpleAccent,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedDay != null
                    ? 'Selected: ${_selectedDay!.toLocal().toString().split(' ')[0]}'
                    : 'Select a date',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                if (value.isEmpty) {
                  return const Center(
                    child: Text(
                      'No diary entry for this day.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.book, color: Colors.pinkAccent),
                      title: Text(value[index], style: const TextStyle(color: Colors.white)),
                      trailing: TextButton(
                        child: const Text('View', style: TextStyle(color: Colors.pinkAccent)),
                        onPressed: () {
                          // TODO: Open full diary entry
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
