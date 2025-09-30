import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;
  const LoginPage({Key? key, required this.onLogin}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('user_name') ?? '';
      _avatarUrl = prefs.getString('user_avatar');
    });
  }

  Future<void> _saveUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _name);
    if (_avatarUrl != null) {
      await prefs.setString('user_avatar', _avatarUrl!);
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _saveUser();
      widget.onLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A183D),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                      child: _avatarUrl == null ? const Icon(Icons.person, size: 40) : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _name,
                      decoration: const InputDecoration(labelText: 'Your Name'),
                      validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                      onSaved: (v) => _name = v!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _avatarUrl,
                      decoration: const InputDecoration(labelText: 'Avatar Image URL (optional)'),
                      onSaved: (v) => _avatarUrl = v?.isNotEmpty == true ? v : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
