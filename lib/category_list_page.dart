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
  var categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.grey,
        appBar: AppBar(
          title: Obx(() {
            if (categoryController.isCategoryChecked.isTrue) {
              return Obx(() =>
                  Text(categoryController.getCheckedRxCategory().toString()));
            } else {
              return Obx(() {
                if (categoryController.isSearchCategory.isFalse) {
                  return const Text(AppString.categories);
                } else {
                  return ListTile(
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
                        });
                      },
                    ),
                  );
                }
              });
            }
          }),
          backgroundColor: AppColor.primary,
          foregroundColor: Colors.black87,
          leading: Obx(() {
            if (categoryController.isCategoryChecked.isTrue) {
              return IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  categoryController.checkUncheckAllRxCategory(checked: false);
                  categoryController.isCategoryChecked.value = false;
                  categoryController.isAllCategoryChecked.value = false;
                },
              );
            } else {
              return const BackButton();
            }
          }),
          actions: [
            Obx(() {
              if (categoryController.isCategoryChecked.isFalse) {
                if (categoryController.isSearchCategory.isFalse) {
                  return IconButton(
                      onPressed: () {
                        categoryController.isSearchCategory.value = true;
                      },
                      icon: const Icon(Icons.search));
                } else {
                  return IconButton(
                      onPressed: () {
                        categoryController.isSearchCategory.value = false;
                        categoryController.searchController.text = "";
                        DatabaseHelper().getCategory().then((value) {
                          categoryController.setRxCategory(value);
                        });
                      },
                      icon: const Icon(Icons.close));
                }
              } else {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        categoryController.deleteCategory().then((value) {
                          if (value) {
                            categoryController.isCategoryChecked.value = false;
                            categoryController.isAllCategoryChecked.value =
                                false;
                          }
                        });
                      },
                    ),
                    Obx(() {
                      if (categoryController.isAllCategoryChecked.isTrue) {
                        return IconButton(
                          icon: const Icon(
                            Icons.checklist,
                            color: AppColor.accent,
                          ),
                          onPressed: () {
                            categoryController.checkUncheckAllRxCategory(
                                checked: false);
                            categoryController.isCategoryChecked.value = false;
                            categoryController.isAllCategoryChecked.value =
                                false;
                          },
                        );
                      } else {
                        return IconButton(
                          icon: const Icon(
                            Icons.checklist,
                          ),
                          onPressed: () {
                            categoryController.checkUncheckAllRxCategory(
                                checked: true);
                            categoryController.isAllCategoryChecked.value =
                                true;
                          },
                        );
                      }
                    })
                  ],
                );
              }
            })
          ],
        ),
        floatingActionButton: Obx(() {
          return categoryController.isCategoryChecked.isFalse
              ? FloatingActionButton(
                  backgroundColor: Colors.black87,
                  child: const Icon(Icons.add),
                  onPressed: () {
                    Get.to(() => const CreateCategoryPage(),
                        arguments: {"CategoryID": 0});
                  },
                )
              : Container();
        }),
        body: FutureBuilder<List<CategoryData>>(
            future: DatabaseHelper().getCategory(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                categoryController.setRxCategory(snapshot.data!);
                return _categoryList();
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }

  Widget _categoryList() {
    return Obx(() => (ListView.builder(
        itemCount: categoryController.lstRxCategory.length,
        itemBuilder: (context, index) {
          CategoryData data = categoryController.lstRxCategory[index];
          data.totalItem ??= 0;
          return ListTile(
            leading: const Icon(Icons.category),
            title: Text(data.categoryName),
            subtitle: Text("${data.totalItem} Items"),
            trailing: Obx(
              () => Checkbox(
                checkColor: AppColor.accent,
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
                          isSelected: newValue,
                          totalItem: data.totalItem));

                  if (categoryController.isCategoryChecked.isFalse) {
                    categoryController.isCategoryChecked.value = true;
                  }

                  if (!newValue!) {
                    categoryController.isAllCategoryChecked.value=false;
                    if (!categoryController.isExistCheckedRxCategory()) {
                      categoryController.isCategoryChecked.value = false;
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
}
