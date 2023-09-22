import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),
    body: ListView(
      children: [
        ListTile(
          title: Text('ログアウト'),
          onTap: () => FirebaseAuth.instance.signOut(),
        )
      ],
    ),
    );
  }
}