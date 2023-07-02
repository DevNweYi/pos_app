import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/item_list_page.dart';
import 'package:pos_app/nav_drawer.dart';
import 'package:pos_app/value/app_color.dart';
import 'package:pos_app/value/app_string.dart';
import 'package:pos_app/widget/menu.dart';

import 'category_list_page.dart';

class ItemMenuPage extends StatefulWidget {
  const ItemMenuPage({super.key});

  @override
  State<ItemMenuPage> createState() => _ItemMenuPageState();
}

class _ItemMenuPageState extends State<ItemMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.grey,
        drawer: const NavDrawer(),
        appBar: AppBar(
          title: const Text(AppString.item),
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.black87,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () {
                  Get.to(const ItemListPage());
                },
                child: const Menu(text: AppString.items, icon: Icons.list)),
            const Divider(),
            InkWell(
                onTap: () {
                  Get.to(const CategoryListPage());
                },
                child: const Menu(
                    text: AppString.categories, icon: Icons.category)),
            const Divider(),
          ],
        ));
  }
}
