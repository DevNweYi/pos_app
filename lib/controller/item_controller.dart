import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/database/database_helper.dart';

import '../model/category_data.dart';
import '../model/item_data.dart';
import '../value/app_string.dart';

class ItemController extends GetxController {
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final salePriceController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final costController = TextEditingController();
  String base64Photo = "";
  Rx<Uint8List> decodedBytes = Uint8List(0).obs;
  Rx<CategoryData> dropdownvalue =
      CategoryData(categoryId: 0, categoryCode: "", categoryName: "").obs;
  RxList<CategoryData> lstCategory = <CategoryData>[].obs;
  RxList<ItemData> lstRxItem = <ItemData>[].obs;

  Future<bool> insert() async {
    bool result = false;
    if (_isValidateControl()) {
      await DatabaseHelper()
          .isDuplicateItemCode(codeController.text)
          .then((value) async {
        if (!value) {
          await DatabaseHelper()
              .insertItem(ItemData.insertItem(
                  categoryId: dropdownvalue.value.categoryId,
                  itemCode: codeController.text,
                  itemName: nameController.text,
                  salePrice: salePriceController.text.isEmpty
                      ? 0
                      : int.parse(salePriceController.text),
                  purchasePrice: purchasePriceController.text.isEmpty
                      ? 0
                      : int.parse(purchasePriceController.text),
                  cost: costController.text.isEmpty
                      ? 0
                      : int.parse(costController.text),
                  base64Photo: base64Photo))
              .then((value) {
            if (value != 0) {
              Get.snackbar(AppString.appName, AppString.savedItem,
                  snackPosition: SnackPosition.TOP,
                  icon: const Icon(Icons.check_circle));
              result = true;
              addRxItem(
                  itemId: value,
                  categoryId: dropdownvalue.value.categoryId,
                  base64Photo: base64Photo);
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
    return result;
  }

  void updateItem({required int itemId}) async {
    if (_isValidateControl()) {
      await DatabaseHelper()
          .isDuplicateUpdateItemCode(itemId, codeController.text)
          .then((value) async {
        if (!value) {
          await DatabaseHelper()
              .updateItem(ItemData.updateItem(
                  itemId: itemId,
                  categoryId: dropdownvalue.value.categoryId,
                  itemCode: codeController.text,
                  itemName: nameController.text,
                  salePrice: salePriceController.text.isEmpty
                      ? 0
                      : int.parse(salePriceController.text),
                  purchasePrice: purchasePriceController.text.isEmpty
                      ? 0
                      : int.parse(purchasePriceController.text),
                  cost: costController.text.isEmpty
                      ? 0
                      : int.parse(costController.text),
                  base64Photo: base64Photo))
              .then((value) {
            if (value != 0) {
              removeAndInsertRxItem(
                  itemId: itemId,
                  categoryId: dropdownvalue.value.categoryId,
                  base64Photo: base64Photo);
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

  Future<bool> deleteItem() async {
    bool result = false;
    List<ItemData> list =
        lstRxItem.where((data) => data.isSelected == true).toList();
    List<int> lstItemID = [];
    for (int i = 0; i < list.length; i++) {
      lstItemID.add(list[i].itemId);
    }

    await DatabaseHelper().deleteItem(lstItemID).then((value) {
      if (value != 0) {
        removeCheckedRxItem();
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
      Get.snackbar(AppString.appName, AppString.enterCode,
          snackPosition: SnackPosition.TOP, icon: const Icon(Icons.warning));
      return false;
    } else if (nameController.text.isEmpty) {
      Get.snackbar(AppString.appName, AppString.enterName,
          snackPosition: SnackPosition.TOP, icon: const Icon(Icons.warning));
      return false;
    } else if (dropdownvalue.value.categoryId == 0) {
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
    base64Photo = "";
    decodedBytes.value = Uint8List(0);
    if (lstCategory.isNotEmpty) {
      dropdownvalue.value = lstCategory[0];
    }
  }

  void fillData(dynamic argumentData) {
    codeController.text = argumentData["ItemCode"];
    nameController.text = argumentData["ItemName"];
    salePriceController.text = argumentData["SalePrice"].toString();
    purchasePriceController.text = argumentData["PurchasePrice"].toString();
    costController.text = argumentData["Cost"].toString();
    base64Photo = argumentData["Base64Photo"];
    decodedBytes.value = decode(base64Photo);

    int categoryId = argumentData["CategoryID"];
    for (int i = 0; i < lstCategory.length; i++) {
      if (lstCategory[i].categoryId == categoryId) {
        dropdownvalue.value = lstCategory[i];
        break;
      }
    }
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
        salePrice: salePriceController.text.isEmpty
            ? 0
            : int.parse(salePriceController.text),
        purchasePrice: purchasePriceController.text.isEmpty
            ? 0
            : int.parse(purchasePriceController.text),
        cost: costController.text.isEmpty ? 0 : int.parse(costController.text),
        base64Photo: base64Photo));
    lstRxItem.refresh();
  }

  void removeAndInsertRxItem(
      {required int itemId,
      required int categoryId,
      required String base64Photo}) {
    int index = lstRxItem.indexWhere((element) => element.itemId == itemId);
    lstRxItem.removeAt(index);
    lstRxItem.insert(
        index,
        ItemData(
            itemId: itemId,
            categoryId: categoryId,
            itemCode: codeController.text,
            itemName: nameController.text,
            salePrice: salePriceController.text.isEmpty
                ? 0
                : int.parse(salePriceController.text),
            purchasePrice: purchasePriceController.text.isEmpty
                ? 0
                : int.parse(purchasePriceController.text),
            cost: costController.text.isEmpty
                ? 0
                : int.parse(costController.text),
            base64Photo: base64Photo));
    lstRxItem.refresh();
  }

  void setRxItem(List<ItemData> lstItem) {
    lstRxItem = lstItem.obs;
    lstRxItem.refresh();
  }

  void checkUncheckRxItem({required int index, required bool checked}) {
    lstRxItem[index].isSelected = checked;
    lstRxItem.refresh();
  }

  bool isExistCheckedRxItem() {
    List<ItemData> list =
        lstRxItem.where((data) => data.isSelected == true).toList();
    if (list.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void checkUncheckAllRxItem({required bool checked}) {
    for (int i = 0; i < lstRxItem.length; i++) {
      lstRxItem[i].isSelected = checked;
    }
    lstRxItem.refresh();
  }

  int getCheckedRxItem() {
    List<ItemData> list =
        lstRxItem.where((data) => data.isSelected == true).toList();
    return list.length;
  }

  void removeCheckedRxItem() {
    lstRxItem.removeWhere((element) => element.isSelected == true);
    lstRxItem.refresh();
  }

  String convertBase64Photo(dynamic image) {
    final bytes = File(image.path.toString()).readAsBytesSync();
    String base64Photo = base64Encode(bytes);
    return base64Photo;
  }

  Uint8List decode(String base64Photo) {
    Uint8List decodedBytes = base64Decode(base64Photo);
    return decodedBytes;
  }
}
