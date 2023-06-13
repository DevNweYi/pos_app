import 'package:flutter/material.dart';
import 'package:pos_app/nav_drawer.dart';
import 'package:pos_app/value/app_string.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text(AppString.purchase)),
      
    );
  }
}