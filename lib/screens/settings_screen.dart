import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  String storageType = 'Local';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0A183D),
        appBar: AppBar(
          title: Text('Settings'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Switch(
                    value: notificationsEnabled,
                    onChanged: (val) {
                      setState(() {
                        notificationsEnabled = val;
                      });
                    },
                    activeColor: Colors.yellow[700],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Storage', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text(storageType, style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
