import 'package:flutter/material.dart';
import 'package:pos_app/nav_drawer.dart';
import 'package:pos_app/value/app_string.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text(AppString.setting)),

    );
  }
}