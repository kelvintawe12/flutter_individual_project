import 'package:flutter/material.dart';
import 'screens/today_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_settings_page.dart';
import 'entry_point.dart';

void main() {
  runApp(StudyPlannerApp());
}

class StudyPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Planner',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Color(0xFF0A183D),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF0A183D),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0A183D),
          selectedItemColor: Colors.yellow[700],
          unselectedItemColor: Colors.white,
        ),
      ),
      initialRoute: '/', // EntryPoint
      routes: {
        '/': (context) => EntryPoint(),
        '/main': (context) => MainNavigation(),
        '/today': (context) => TodayScreen(),
        '/calendar': (context) => CalendarScreen(),
        '/settings': (context) => SettingsScreen(),
        '/profile': (context) => ProfileSettingsPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    TodayScreen(),
    CalendarScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
