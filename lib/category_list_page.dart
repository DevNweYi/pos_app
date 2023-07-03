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
  bool _isCategoryLongPressed = false, _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.grey,
        appBar: _isCategoryLongPressed ? _deleteAppBar() : _defaultAppBar(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(() => const CreateCategoryPage(),
                arguments: {"CategoryID": 0});
          },
        ),
        body: FutureBuilder<List<CategoryData>>(
          future: DatabaseHelper().getCategory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              categoryController.lstRxCategory = snapshot.data!.obs;
              return _categoryList();
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const Center(
                child: CircularProgressIndicator(
              color: AppColor.primary,
            ));
          },
        ));
  }

  Widget _categoryList() {
    return Obx(() => (ListView.builder(
        itemCount: categoryController.lstRxCategory.length,
        itemBuilder: (context, index) {
          CategoryData data = categoryController.lstRxCategory[index];
          return ListTile(
            leading: !_isCategoryLongPressed
                ? const Icon(Icons.category)
                : Obx(
                    () => Checkbox(
                        value:
                            categoryController.lstRxCategory[index].isSelected,
                        onChanged: (bool? newValue) {
                          categoryController.lstRxCategory[index].isSelected =
                              newValue!;
                          categoryController.lstRxCategory.refresh();
                        }),
                  ),
            title: Text(data.categoryName),
            subtitle: Text("0 Items"),
            onTap: () {
              Get.to(() => const CreateCategoryPage(), arguments: {
                "CategoryID": data.categoryId,
                "CategoryCode": data.categoryCode,
                "CategoryName": data.categoryName,
              });
            },
            onLongPress: () {
              categoryController.lstRxCategory[index].isSelected =true;
              categoryController.lstRxCategory.refresh();
              setState(() {
                _isCategoryLongPressed = true;               
                //categoryController.lstRxCategory.refresh();
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
                  customSearchBar = const ListTile(
                    leading: Icon(
                      Icons.search,
                    ),
                    title: TextField(
                      decoration: InputDecoration(
                          hintText: AppString.search, border: InputBorder.none),
                      style: TextStyle(color: Colors.black87),
                      cursorColor: Colors.black87,
                    ),
                  );
                } else {
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text(AppString.categories);
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
          setState(() {
            _isCategoryLongPressed = false;
          });
        },
      ),
      title: Text("1"),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {},
        )
      ],
    );
  }
}
