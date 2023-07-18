import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/database/database_helper.dart';

import '../model/item_data.dart';
import '../value/app_string.dart';

class ItemController extends GetxController {
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final salePriceController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final costController = TextEditingController();
  RxList<ItemData> lstRxItem = <ItemData>[].obs;

  void insert({required int categoryId, required String base64Photo}) {
    if (_isValidateControl(categoryId: categoryId)) {
      DatabaseHelper().isDuplicateItemCode(codeController.text).then((value) {
        if (!value) {
          DatabaseHelper()
              .insertItem(ItemData.insertItem(
                  categoryId: categoryId,
                  itemCode: codeController.text,
                  itemName: nameController.text,
                  salePrice: int.parse(salePriceController.text),
                  purchasePrice: int.parse(purchasePriceController.text),
                  cost: int.parse(costController.text),
                  base64Photo: base64Photo))
              .then((value) {
            if (value != 0) {
              addRxItem(
                  itemId: value,
                  categoryId: categoryId,
                  base64Photo: base64Photo);
              Get.snackbar(AppString.appName, AppString.savedItem,
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

  bool _isValidateControl({required int categoryId}) {
    if (codeController.text.isEmpty) {
      Get.snackbar(AppString.appName, AppString.enterCode,
          snackPosition: SnackPosition.TOP, icon: const Icon(Icons.warning));
      return false;
    } else if (nameController.text.isEmpty) {
      Get.snackbar(AppString.appName, AppString.enterName,
          snackPosition: SnackPosition.TOP, icon: const Icon(Icons.warning));
      return false;
    } else if (categoryId == 0) {
      Get.snackbar(AppString.appName, AppString.notFoundCategory,
          snackPosition: SnackPosition.TOP, icon: const Icon(Icons.warning));
      return false;
    }
    return true;
  }

  void clearControl() {
    codeController.text = "";
    nameController.text = "";
    salePriceController.text = "";
    purchasePriceController.text = "";
    costController.text = "";
  }

  void addRxItem(
      {required int itemId,
      required int categoryId,
      required String base64Photo}) {
    lstRxItem.add(ItemData(
        itemId: itemId,
        categoryId: categoryId,
        itemCode: codeController.text,
        itemName: nameController.text,
        salePrice: int.parse(salePriceController.text),
        purchasePrice: int.parse(purchasePriceController.text),
        cost: int.parse(costController.text),
        base64Photo: base64Photo));
    lstRxItem.refresh();
  }

  void setRxItem(List<ItemData> lstItem) {
    lstRxItem = lstItem.obs;
    lstRxItem.refresh();
  }
}
