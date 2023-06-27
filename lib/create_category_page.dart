import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/create_category_controller.dart';
import 'value/app_color.dart';
import 'value/app_string.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  var createCategoryController = Get.put(CreateCategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBar(
        title: const Text(AppString.createCategory),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.black87,
        actions: [
          TextButton(
            child: const Text(
              AppString.save,
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: TextField(
                controller: createCategoryController.codeController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    hintText: AppString.code,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: TextField(
                controller: createCategoryController.nameController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                    hintText: AppString.name,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
