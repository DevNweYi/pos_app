import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pos_app/item_menu_page.dart';
import 'package:pos_app/receipt_page.dart';
import 'package:pos_app/sale_page.dart';
import 'package:pos_app/setting_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const SalePage(),
      builder: EasyLoading.init(),
      // Register routes
      routes: {
        '/receipt_page': (BuildContext ctx) => const ReceiptPage(),
        '/item_page': (BuildContext ctx) => const ItemMenuPage(),
        '/setting_page': (BuildContext ctx) => const SettingPage(),
      },
    );
  }
}
