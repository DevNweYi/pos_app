import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/database/database_helper.dart';

import '../model/category_data.dart';
import '../value/app_string.dart';

class CreateCategoryController extends GetxController {
  final codeController = TextEditingController();
  final nameController = TextEditingController();

  void create() {
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
              Get.snackbar(AppString.appName, AppString.savedCategory,
                  snackPosition: SnackPosition.TOP,
                  icon: const Icon(Icons.check_circle));
              clearControl();
            } else {
              Get.snackbar(AppString.appName, AppString.somethingWentWrong,
                  snackPosition: SnackPosition.TOP,
                  icon: const Icon(Icons.error));
            }
            print("value after inserting category $value");
          });
        } else {
          Get.snackbar(AppString.appName, AppString.duplicateCode,
              snackPosition: SnackPosition.TOP,
              icon: const Icon(Icons.warning));
        }
      });
    }
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
}
