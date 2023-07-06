import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/create_category_page.dart';
import 'package:pos_app/database/database_helper.dart';
import 'package:pos_app/value/app_string.dart';

import 'controller/category_controller.dart';
import 'model/category_data.dart';
import 'value/app_color.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text(AppString.categories);
  var categoryController = Get.put(CategoryController());
  bool _isCategoryChecked = false;

  @override
  void initState() {
    DatabaseHelper().getCategory().then((value) {
      categoryController.setRxCategory(value);
      setState(() {
        _categoryList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.grey,
        appBar: _isCategoryChecked ? _deleteAppBar() : _defaultAppBar(),
        floatingActionButton: !_isCategoryChecked
            ? FloatingActionButton(
                backgroundColor: Colors.black87,
                child: const Icon(Icons.add),
                onPressed: () {
                  Get.to(() => const CreateCategoryPage(),
                      arguments: {"CategoryID": 0});
                },
              )
            : Container(),
        body: _categoryList());
  }

  Widget _categoryList() {
    return Obx(() => (ListView.builder(
        itemCount: categoryController.lstRxCategory.length,
        itemBuilder: (context, index) {
          CategoryData data = categoryController.lstRxCategory[index];
          return ListTile(
            leading: const Icon(Icons.category),
            title: Text(data.categoryName),
            subtitle: Text("0 Items"),
            trailing: Obx(
              () => Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.black45),
                value:
                    categoryController.lstRxCategory[index].isSelected ?? false,
                onChanged: (bool? newValue) {
                  categoryController.checkUncheckRxCategory(
                      index,
                      CategoryData(
                          categoryId: data.categoryId,
                          categoryCode: data.categoryCode,
                          categoryName: data.categoryName,
                          isSelected: newValue));

                  if (!_isCategoryChecked) {
                    setState(() {
                      _isCategoryChecked = true;
                    });
                  }

                  if (!newValue!) {
                    if (!categoryController.isExistCheckedRxCategory()) {
                      setState(() {
                        _isCategoryChecked = false;
                      });
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            onTap: () {
              Get.to(() => const CreateCategoryPage(), arguments: {
                "CategoryID": data.categoryId,
                "CategoryCode": data.categoryCode,
                "CategoryName": data.categoryName,
              });
            },
          );
        })));
  }

  PreferredSizeWidget _defaultAppBar() {
    return AppBar(
        title: customSearchBar,
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: customIcon,
            onPressed: (() {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.close);
                  customSearchBar = ListTile(
                    leading: const Icon(
                      Icons.search,
                    ),
                    title: TextField(
                      controller: categoryController.searchController,
                      decoration: const InputDecoration(
                          hintText: AppString.search, border: InputBorder.none),
                      style: const TextStyle(color: Colors.black87),
                      cursorColor: Colors.black87,
                      onChanged: (value) {                       
                        DatabaseHelper()
                            .getCategory(searchValue: value)
                            .then((lstCategory) {
                          categoryController.setRxCategory(lstCategory);
                          setState(() {
                            _categoryList();
                          });
                        });
                      },
                    ),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text(AppString.categories);
                  categoryController.searchController.text="";
                  DatabaseHelper().getCategory().then((value) {
                    categoryController.setRxCategory(value);
                    setState(() {
                      _categoryList();
                    });
                  });
                }
              });
            }),
          )
        ]);
  }

  PreferredSizeWidget _deleteAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          categoryController.unCheckRxCategory();
          setState(() {
            _isCategoryChecked = false;
          });
        },
      ),
      title:
          Obx(() => Text(categoryController.getCheckedRxCategory().toString())),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.checklist),
          onPressed: () {},
        )
      ],
    );
  }
}
