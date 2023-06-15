import 'package:flutter/material.dart';
import 'package:pos_app/nav_drawer.dart';
import 'package:pos_app/value/app_string.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text(AppString.item)),
      
    );
  }
}