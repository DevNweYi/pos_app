import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/category_controller.dart';
import 'value/app_color.dart';
import 'value/app_string.dart';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  var categoryController = Get.put(CategoryController());
  dynamic argumentData=Get.arguments;
  late int categoryId;
  bool isUpdate=false;

  @override
  void initState() {
    categoryId = argumentData["CategoryID"];
    if(categoryId != 0){
      isUpdate=true;
      categoryController.fillData(argumentData);
    }else{
      categoryController.clearControl();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBar(
        title: !isUpdate? const Text(AppString.createCategory) : const Text(AppString.updateCategory),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.black87,
        actions: [
          TextButton(
            child: const Text(
              AppString.save,
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () {
              if(!isUpdate){
                  categoryController.insert();
              }else{
                  categoryController.updateCategory(categoryId);
              }             
            },
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
                controller: categoryController.codeController,
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
                controller: categoryController.nameController,
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
