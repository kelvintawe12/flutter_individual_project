import 'package:flutter/material.dart';
import '../models/task.dart';
import '../storage/task_storage.dart';
import 'new_task_screen.dart';

class TodayScreen extends StatefulWidget {
  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  List<Task> _tasks = [];
  bool _loading = true;

  bool _reminderShown = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkReminders());
  }

  Future<void> _loadTasks() async {
    final allTasks = await TaskStorage.loadTasks();
    final today = DateTime.now();
    setState(() {
      _tasks = allTasks.where((task) =>
        task.dueDate.year == today.year &&
        task.dueDate.month == today.month &&
        task.dueDate.day == today.day
      ).toList();
      _loading = false;
    });
    _checkReminders();
  }
  void _checkReminders() {
    if (_reminderShown) return;
    final now = DateTime.now();
    final soonTasks = _tasks.where((task) {
      if (task.reminderTime == null) return false;
      final reminderDateTime = DateTime(
        now.year, now.month, now.day, task.reminderTime!.hour, task.reminderTime!.minute);
      return reminderDateTime.isAfter(now) &&
        reminderDateTime.difference(now).inMinutes <= 60;
    }).toList();
    if (soonTasks.isNotEmpty) {
      _reminderShown = true;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Upcoming Reminders'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: soonTasks.map((task) => ListTile(
              title: Text(task.title),
              subtitle: task.description != null ? Text(task.description!) : null,
            )).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _addTask(Task task) async {
    await TaskStorage.addTask(task);
    await _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0A183D),
        appBar: AppBar(
          title: Text('Today'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _loading
                      ? Center(child: CircularProgressIndicator())
                      : _tasks.isEmpty
                          ? Center(child: Text('No tasks for today'))
                          : ListView(
                              padding: EdgeInsets.all(16),
                              children: [
                                Text('Remind 4sasks', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                SizedBox(height: 8),
                                ..._tasks.map((task) => ListTile(
                                      title: Text(task.title),
                                      subtitle: task.description != null ? Text(task.description!) : null,
                                    )),
                              ],
                            ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewTaskScreen(
                        onTaskCreated: (task) async {
                          await _addTask(task);
                        },
                      ),
                    ),
                  );
                },
                child: Text('New Task', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
