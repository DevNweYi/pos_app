import 'package:flutter/material.dart';
import 'package:pos_app/nav_drawer.dart';
import 'package:pos_app/value/app_string.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text(AppString.sale)),

    );
  }
}