import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';

class NewTaskScreen extends StatefulWidget {
  final Function(Task) onTaskCreated;
  final Task? existingTask;
  const NewTaskScreen({Key? key, required this.onTaskCreated, this.existingTask}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

  class _NewTaskScreenState extends State<NewTaskScreen> {
    final _formKey = GlobalKey<FormState>();
    late String _title;
    String? _description;
    late DateTime _dueDate;
    TimeOfDay? _reminderTime;

    @override
    void initState() {
      super.initState();
      if (widget.existingTask != null) {
        _title = widget.existingTask!.title;
        _description = widget.existingTask!.description;
        _dueDate = widget.existingTask!.dueDate;
        _reminderTime = widget.existingTask!.reminderTime;
      } else {
        _title = '';
        _description = null;
        _dueDate = DateTime.now();
        _reminderTime = null;
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A183D),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(widget.existingTask != null ? 'Edit Task' : 'New Task'),
          backgroundColor: const Color(0xFF0A183D),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _title,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
                  onSaved: (value) => _title = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _description,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onSaved: (value) => _description = value,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  title: Text('Due Date: ${_dueDate.year}-${_dueDate.month.toString().padLeft(2, '0')}-${_dueDate.day.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.black)),
                  trailing: const Icon(Icons.calendar_today, color: Colors.black),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _dueDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => _dueDate = picked);
                  },
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  value: _reminderTime != null,
                  onChanged: (val) async {
                    if (val) {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: _reminderTime ?? TimeOfDay.now(),
                      );
                      if (picked != null) setState(() => _reminderTime = picked);
                    } else {
                      setState(() => _reminderTime = null);
                    }
                  },
                  title: const Text('Set Reminder', style: TextStyle(color: Colors.white)),
                  activeColor: Colors.yellow,
                ),
                if (_reminderTime != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text('Reminder: ${_reminderTime!.format(context)}', style: const TextStyle(color: Colors.white)),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final task = Task(
                        id: widget.existingTask?.id ?? const Uuid().v4(),
                        title: _title,
                        description: _description,
                        dueDate: _dueDate,
                        reminderTime: _reminderTime,
                      );
                      widget.onTaskCreated(task);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
