import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/database/database_helper.dart';

import '../model/category_data.dart';
import '../value/app_string.dart';

class CategoryController extends GetxController {
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final searchController = TextEditingController();
  RxList<CategoryData> lstRxCategory = <CategoryData>[].obs;

  void insert() {
    if (_isValidateControl()) {
      DatabaseHelper()
          .isDuplicateCategoryCode(codeController.text)
          .then((value) {
        if (!value) {
          DatabaseHelper()
              .insertCategory(CategoryData.insertCategory(
                  categoryCode: codeController.text,
                  categoryName: nameController.text))
              .then((value) {
            if (value != 0) {
              addRxCategory(value);
              Get.snackbar(AppString.appName, AppString.savedCategory,
                  snackPosition: SnackPosition.TOP,
                  icon: const Icon(Icons.check_circle));
              clearControl();
            } else {
              Get.snackbar(AppString.appName, AppString.somethingWentWrong,
                  snackPosition: SnackPosition.TOP,
                  icon: const Icon(Icons.error));
            }
          });
        } else {
          Get.snackbar(AppString.appName, AppString.duplicateCode,
              snackPosition: SnackPosition.TOP,
              icon: const Icon(Icons.warning));
        }
      });
    }
  }

  void updateCategory(int categoryId) {
    if (_isValidateControl()) {
      DatabaseHelper()
          .isDuplicateUpdateCategoryCode(categoryId, codeController.text)
          .then((value) {
        if (!value) {
          DatabaseHelper()
              .updateCategory(CategoryData.updateCategory(
                  categoryId: categoryId,
                  categoryCode: codeController.text,
                  categoryName: nameController.text))
              .then((value) {
            if (value != 0) {
              removeAndInsertRxCategory(categoryId);
              Get.back();
            } else {
              Get.snackbar(AppString.appName, AppString.somethingWentWrong,
                  snackPosition: SnackPosition.TOP,
                  icon: const Icon(Icons.error));
            }
          });
        } else {
          Get.snackbar(AppString.appName, AppString.duplicateCode,
              snackPosition: SnackPosition.TOP,
              icon: const Icon(Icons.warning));
        }
      });
    }
  }

  Future<bool> deleteCategory() async {
    bool result = false;
    List<CategoryData> list =
        lstRxCategory.where((data) => data.isSelected == true).toList();
    List<int> lstCategoryID = [];
    for (int i = 0; i < list.length; i++) {
      lstCategoryID.add(list[i].categoryId);
    }

    await DatabaseHelper().deleteCategory(lstCategoryID).then((value) {
      if (value != 0) {
        removeCheckedRxCategory();
        Get.snackbar(AppString.appName, AppString.deleted,
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.check_circle));
        result = true;
      } else {
        Get.snackbar(AppString.appName, AppString.somethingWentWrong,
            snackPosition: SnackPosition.TOP, icon: const Icon(Icons.error));
        result = false;
      }
    });
    return result;
  }

  bool _isValidateControl() {
    if (codeController.text.isEmpty) {
      Get.snackbar(AppString.appName, AppString.enterCategoryCode,
          snackPosition: SnackPosition.TOP, icon: const Icon(Icons.warning));
      return false;
    } else if (nameController.text.isEmpty) {
      Get.snackbar(AppString.appName, AppString.enterCategoryName,
          snackPosition: SnackPosition.TOP, icon: const Icon(Icons.warning));
      return false;
    }
    return true;
  }

  void clearControl() {
    codeController.text = "";
    nameController.text = "";
  }

  void fillData(dynamic argumentData) {
    codeController.text = argumentData["CategoryCode"];
    nameController.text = argumentData["CategoryName"];
  }

  void addRxCategory(int categoryId) {
    lstRxCategory.add(CategoryData(
        categoryId: categoryId,
        categoryCode: codeController.text,
        categoryName: nameController.text));
    lstRxCategory.refresh();
  }

  void removeAndInsertRxCategory(int categoryId) {
    int index =
        lstRxCategory.indexWhere((element) => element.categoryId == categoryId);
    lstRxCategory.removeAt(index);
    lstRxCategory.insert(
        index,
        CategoryData(
            categoryId: categoryId,
            categoryCode: codeController.text,
            categoryName: nameController.text));
    lstRxCategory.refresh();
  }

  void setRxCategory(List<CategoryData> lstCategory) {
    lstRxCategory = lstCategory.obs;
    lstRxCategory.refresh();
  }

  void checkUncheckRxCategory(int index, CategoryData categoryData) {
    lstRxCategory.removeAt(index);
    lstRxCategory.insert(
        index,
        CategoryData(
            categoryId: categoryData.categoryId,
            categoryCode: categoryData.categoryCode,
            categoryName: categoryData.categoryName,
            isSelected: categoryData.isSelected));
    lstRxCategory.refresh();
  }

  void checkUncheckAllRxCategory({required bool checked}) {
    for (int i = 0; i < lstRxCategory.length; i++) {
      lstRxCategory[i].isSelected = checked;
    }
    lstRxCategory.refresh();
  }

  bool isExistCheckedRxCategory() {
    List<CategoryData> list =
        lstRxCategory.where((data) => data.isSelected == true).toList();
    if (list.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  int getCheckedRxCategory() {
    List<CategoryData> list =
        lstRxCategory.where((data) => data.isSelected == true).toList();
    return list.length;
  }

  void removeCheckedRxCategory(){
    lstRxCategory.removeWhere((element) => element.isSelected == true);
    lstRxCategory.refresh();
  }

}
