import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/item_list_page.dart';
import 'package:pos_app/nav_drawer.dart';
import 'package:pos_app/value/app_string.dart';
import 'package:pos_app/widget/menu.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({super.key});

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavDrawer(),
        appBar: AppBar(title: const Text(AppString.item)),
        body: Column(
          children: [
            const SizedBox(height: 10,),
            InkWell(
                onTap: () {
                  Get.to(const ItemListPage());
                },
                child:
                    const Menu(text: AppString.items, icon: Icons.list)),
            const Divider(),
            InkWell(
                onTap: () {
                  print('category clicked');
                },
                child: const Menu(
                    text: AppString.categories, icon: Icons.category)),
            const Divider(),
          ],
        ));
  }
}
