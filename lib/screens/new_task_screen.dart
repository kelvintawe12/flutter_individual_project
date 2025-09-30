import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';

class NewTaskScreen extends StatefulWidget {
  final Function(Task) onTaskCreated;
  const NewTaskScreen({Key? key, required this.onTaskCreated}) : super(key: key);

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String? _description;
  DateTime _dueDate = DateTime.now();
  TimeOfDay? _reminderTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A183D),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('New Task'),
        backgroundColor: Color(0xFF0A183D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
                onSaved: (value) => _title = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSaved: (value) => _description = value,
                maxLines: 2,
              ),
              SizedBox(height: 16),
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: Text('Due Date: ${_dueDate.year}-${_dueDate.month.toString().padLeft(2, '0')}-${_dueDate.day.toString().padLeft(2, '0')}', style: TextStyle(color: Colors.black)),
                trailing: Icon(Icons.calendar_today, color: Colors.black),
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
              SizedBox(height: 16),
              SwitchListTile(
                value: _reminderTime != null,
                onChanged: (val) async {
                  if (val) {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => _reminderTime = picked);
                  } else {
                    setState(() => _reminderTime = null);
                  }
                },
                title: Text('Set Reminder', style: TextStyle(color: Colors.white)),
                activeColor: Colors.yellow[700],
              ),
              if (_reminderTime != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text('Reminder: ${_reminderTime!.format(context)}', style: TextStyle(color: Colors.white)),
                ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 18),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final task = Task(
                      id: Uuid().v4(),
                      title: _title,
                      description: _description,
                      dueDate: _dueDate,
                      reminderTime: _reminderTime,
                    );
                    widget.onTaskCreated(task);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
