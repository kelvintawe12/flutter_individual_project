import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_settings_page.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  String storageType = 'Local';
  int _taskCount = 0;
  int _storageBytes = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStorageInfo();
    });
  }

  Future<void> _loadStorageInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      final tasks = prefs.getStringList('tasks');
      int bytes = 0;
      int count = 0;
      if (tasks != null) { 
        count = tasks.length;
        for (final t in tasks) {
          bytes += t.length; 
        }
      }
      setState(() {
        _taskCount = count;
        _storageBytes = bytes;
      });
    } catch (e) {
      print('Error loading storage info: $e');
      if (mounted) {
        setState(() {
          _taskCount = -1;
          _storageBytes = -1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0A183D),
        appBar: AppBar(
          title: Text('Settings'),
          elevation: 0,
          backgroundColor: Color(0xFF0A183D),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      title: Text('Notifications', style: TextStyle(fontSize: 18, color: Colors.black)),
                      trailing: Switch(
                        value: notificationsEnabled,
                        onChanged: (val) {
                          setState(() {
                            notificationsEnabled = val;
                          });
                        },
                        activeColor: Colors.yellow[700],
                      ),
                    ),
                    Divider(height: 0, thickness: 1, indent: 20, endIndent: 20),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      title: Text('Storage', style: TextStyle(fontSize: 18, color: Colors.black)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(storageType, style: TextStyle(fontSize: 18, color: Colors.black)),
                          Icon(Icons.chevron_right, color: Colors.grey[600]),
                        ],
                      ),
                      onTap: () {},
                    ),
                    Divider(height: 0, thickness: 1, indent: 20, endIndent: 20),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Edit Profile'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tasks stored:', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                          Text('$_taskCount', style: TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Storage used:', style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                          Text('${(_storageBytes / 1024).toStringAsFixed(2)} KB', style: TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
