import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/task.dart';
import '../storage/task_storage.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Task>> _tasksByDate = {};
  List<Task> _selectedTasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final allTasks = await TaskStorage.loadTasks();
    Map<DateTime, List<Task>> map = {};
    for (var task in allTasks) {
      final date = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);
      map.putIfAbsent(date, () => []).add(task);
    }
    setState(() {
      _tasksByDate = map;
      _selectedDay = _selectedDay ?? DateTime.now();
      _selectedTasks = _tasksByDate[_selectedDay] ?? [];
      _loading = false;
    });
  }

  List<Task> _getTasksForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _tasksByDate[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0A183D),
        appBar: AppBar(
          title: Text('My Study Planner'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _loading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.all(16),
                      child: TableCalendar<Task>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2100, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                            _selectedTasks = _getTasksForDay(selectedDay);
                          });
                        },
                        eventLoader: _getTasksForDay,
                        calendarStyle: CalendarStyle(
                          markerDecoration: BoxDecoration(
                            color: Colors.yellow[700],
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: BoxDecoration(
                            color: Colors.indigo[200],
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.indigo,
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.all(16),
                      child: _selectedTasks.isEmpty
                          ? Text('No tasks for this day')
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _selectedTasks
                                  .map((task) => ListTile(
                                        title: Text(task.title),
                                        subtitle: task.description != null ? Text(task.description!) : null,
                                      ))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
