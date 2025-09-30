import 'package:flutter/material.dart';
import '../models/task.dart';
import '../storage/task_storage.dart';
import 'new_task_screen.dart';
import '../widgets/user_profile_avatar.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';

class TodayScreen extends StatefulWidget {
  @override
  State<TodayScreen> createState() => _TodayScreenState();
}


class _TodayScreenState extends State<TodayScreen> {
  List<Task> _tasks = [];
  bool _loading = true;
  List<Timer>? _reminderTimers = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    if (_reminderTimers != null) {
      for (final timer in _reminderTimers!) {
        timer.cancel();
      }
    }
    super.dispose();
  }

  Future<void> _loadTasks() async {
    // Cancel any previous timers
    if (_reminderTimers != null) {
      for (final timer in _reminderTimers!) {
        timer.cancel();
      }
      _reminderTimers!.clear();
    }

    final allTasks = await TaskStorage.loadTasks();
    final today = DateTime.now();
    final todayTasks = allTasks.where((task) =>
      task.dueDate.year == today.year &&
      task.dueDate.month == today.month &&
      task.dueDate.day == today.day
    ).toList();
    setState(() {
      _tasks = todayTasks;
      _loading = false;
    });

    // Schedule timers for reminders
    final now = DateTime.now();
    for (final task in todayTasks) {
      if (task.reminderTime != null) {
        final reminderDateTime = DateTime(
          now.year, now.month, now.day, task.reminderTime!.hour, task.reminderTime!.minute);
        final diff = reminderDateTime.difference(now);
        if (diff.inMilliseconds > 0) {
          _reminderTimers?.add(Timer(diff, () {
            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  title: Row(
                    children: [
                      Lottie.asset('assets/success.json', width: 48, height: 48, repeat: false),
                      SizedBox(width: 12),
                      Text('Reminder!', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('It\'s time for:'),
                      SizedBox(height: 12),
                      Text(task.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      if (task.description != null && task.description!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(task.description!),
                        ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Close', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            }
          }));
        }
      }
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
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: UserProfileAvatar(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
          ],
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
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 180,
                                    height: 180,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child:  
                                        // Lottie animation for empty state
                                        // Download a Lottie JSON from lottiefiles.com or use a network asset
                                        // Example: https://assets10.lottiefiles.com/packages/lf20_jzv1zqxr.json
                                        // You can replace the URL with any Lottie animation you like
                                        // Requires lottie package
                                        Lottie.asset('assets/success.json'),
                                    ),
                                  ),
                                  Text('No tasks for today', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.all(16),
                              itemCount: _tasks.length,
                              separatorBuilder: (context, i) => SizedBox(height: 16),
                              itemBuilder: (context, i) {
                                final task = _tasks[i];
                                final imageUrls = [
                                  'https://images.pexels.com/photos/4145196/pexels-photo-4145196.jpeg',
                                  'https://images.pexels.com/photos/1181675/pexels-photo-1181675.jpeg',
                                  'https://images.pexels.com/photos/4145191/pexels-photo-4145191.jpeg',
                                  'https://images.pexels.com/photos/4145193/pexels-photo-4145193.jpeg',
                                  'https://images.pexels.com/photos/4145194/pexels-photo-4145194.jpeg',
                                ];
                                final imgUrl = imageUrls[i % imageUrls.length];
                                return GestureDetector(
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.all(24.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(16),
                                                      child: Image.network(imgUrl, width: 120, height: 120, fit: BoxFit.cover),
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text(task.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                                                  if (task.description != null && task.description!.isNotEmpty)
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 8.0),
                                                      child: Text(task.description!, style: TextStyle(fontSize: 16)),
                                                    ),
                                                  SizedBox(height: 16),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.calendar_today, size: 18, color: Colors.indigo),
                                                      SizedBox(width: 6),
                                                      Text('${task.dueDate.year}-${task.dueDate.month.toString().padLeft(2, '0')}-${task.dueDate.day.toString().padLeft(2, '0')}', style: TextStyle(fontSize: 16, color: Colors.indigo)),
                                                      if (task.reminderTime != null) ...[
                                                        SizedBox(width: 16),
                                                        Icon(Icons.access_time, size: 18, color: Colors.yellow[700]),
                                                        SizedBox(width: 4),
                                                        Text(task.reminderTime!.format(context), style: TextStyle(fontSize: 16, color: Colors.yellow[700])),
                                                      ],
                                                    ],
                                                  ),
                                                  SizedBox(height: 16),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.notifications_active, color: task.reminderTime != null ? Colors.yellow[700] : Colors.grey[400]),
                                                      SizedBox(width: 8),
                                                      Text(task.reminderTime != null ? 'Reminder set' : 'No reminder', style: TextStyle(fontSize: 16)),
                                                    ],
                                                  ),
                                                  SizedBox(height: 24),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      ElevatedButton.icon(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.indigo,
                                                          foregroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                        ),
                                                        icon: Icon(Icons.edit),
                                                        label: Text('Edit'),
                                                        onPressed: () async {
                                                          Navigator.pop(context);
                                                          await Navigator.push(
                                                            this.context,
                                                            MaterialPageRoute(
                                                              builder: (context) => NewTaskScreen(
                                                                onTaskCreated: (editedTask) async {
                                                                  // Remove old, add new
                                                                  await TaskStorage.deleteTask(task.id);
                                                                  await _addTask(editedTask);
                                                                },
                                                                existingTask: task,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      ElevatedButton.icon(
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.red[700],
                                                          foregroundColor: Colors.white,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                        ),
                                                        icon: Icon(Icons.delete),
                                                        label: Text('Delete'),
                                                        onPressed: () async {
                                                          await TaskStorage.deleteTask(task.id);
                                                          Navigator.pop(context);
                                                          await _loadTasks();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    await _loadTasks();
                                  },
                                  child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              bottomLeft: Radius.circular(16)),
                                          child: Image.network(
                                            imgUrl,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        task.title,
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                    if (task.reminderTime != null)
                                                      Icon(Icons.notifications_active, color: Colors.yellow[700], size: 22),
                                                  ],
                                                ),
                                                if (task.description != null && task.description!.isNotEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 4.0),
                                                    child: Text(
                                                      task.description!,
                                                      style: TextStyle(color: Colors.grey[700]),
                                                    ),
                                                  ),
                                                SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    Icon(Icons.calendar_today, size: 16, color: Colors.indigo),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      '${task.dueDate.year}-${task.dueDate.month.toString().padLeft(2, '0')}-${task.dueDate.day.toString().padLeft(2, '0')}',
                                                      style: TextStyle(fontSize: 14, color: Colors.indigo),
                                                    ),
                                                    if (task.reminderTime != null) ...[
                                                      SizedBox(width: 12),
                                                      Icon(Icons.access_time, size: 16, color: Colors.yellow[700]),
                                                      SizedBox(width: 2),
                                                      Text(
                                                        task.reminderTime!.format(context),
                                                        style: TextStyle(fontSize: 14, color: Colors.yellow[700]),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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
