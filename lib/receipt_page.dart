import 'package:flutter/material.dart';
import 'package:pos_app/nav_drawer.dart';
import 'package:pos_app/value/app_string.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text(AppString.receipt)),
      
    );
  }
}