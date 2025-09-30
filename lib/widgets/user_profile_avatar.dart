import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileAvatar extends StatefulWidget {
  final double radius;
  final VoidCallback? onTap;
  const UserProfileAvatar({Key? key, this.radius = 18, this.onTap}) : super(key: key);

  @override
  State<UserProfileAvatar> createState() => _UserProfileAvatarState();
}

class _UserProfileAvatarState extends State<UserProfileAvatar> {
  String? _avatarUrl;
  String? _name;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarUrl = prefs.getString('user_avatar');
      _name = prefs.getString('user_name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: widget.radius,
            backgroundImage: _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
            child: _avatarUrl == null ? const Icon(Icons.person, size: 18) : null,
          ),
          if (_name != null && _name!.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(_name!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ]
        ],
      ),
    );
  }
}
