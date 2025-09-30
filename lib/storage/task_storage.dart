import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStorage {
  static const String _tasksKey = 'tasks';

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    return tasksJson.map((jsonStr) => Task.fromJson(json.decode(jsonStr))).toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => json.encode(task.toJson())).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  static Future<void> addTask(Task task) async {
    final tasks = await loadTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  static Future<void> deleteTask(String id) async {
    final tasks = await loadTasks();
    tasks.removeWhere((task) => task.id == id);
    await saveTasks(tasks);
  }

  static Future<void> updateTask(Task updatedTask) async {
    final tasks = await loadTasks();
    final idx = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (idx != -1) {
      tasks[idx] = updatedTask;
      await saveTasks(tasks);
    }
  }
}
