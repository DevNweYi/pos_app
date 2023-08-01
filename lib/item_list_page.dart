import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pos_app/create_item_page.dart';
import 'package:pos_app/database/database_helper.dart';
import 'package:pos_app/value/app_string.dart';

import 'controller/item_controller.dart';
import 'model/category_data.dart';
import 'model/item_data.dart';
import 'value/app_color.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  var itemController = Get.put(ItemController());

  @override
  void initState() {
    EasyLoading.show();
    DatabaseHelper().getCategory().then((value) {
      EasyLoading.dismiss();
      if (value.isNotEmpty) {
        itemController.lstCategoryInList.value = value;
        itemController.lstCategoryInList
            .insert(0, itemController.listDefaultCatVal.value);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBar(
        title: Obx(() => itemController.isItemChecked.isFalse
            ? const Text(AppString.items)
            : Obx(() => Text(itemController.getCheckedRxItem().toString()))),
        foregroundColor: Colors.black87,
        backgroundColor: AppColor.primary,
        leading: Obx(() {
          if (itemController.isItemChecked.isTrue) {
            return IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                itemController.checkUncheckAllRxItem(checked: false);
                itemController.isItemChecked.value = false;
                itemController.isAllItemChecked.value = false;
              },
            );
          } else {
            return const BackButton();
          }
        }),
        actions: [
          Obx(() {
            if (itemController.isItemChecked.isTrue) {
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      itemController.deleteItem().then((value) {
                        if (value) {
                          itemController.isItemChecked.value = false;
                          itemController.isAllItemChecked.value = false;
                        }
                      });
                    },
                  ),
                  Obx(() {
                    if (itemController.isAllItemChecked.isTrue) {
                      return IconButton(
                        icon: const Icon(
                          Icons.checklist,
                          color: AppColor.accent,
                        ),
                        onPressed: () {
                          itemController.checkUncheckAllRxItem(checked: false);
                          itemController.isAllItemChecked.value = false;
                        },
                      );
                    } else {
                      return IconButton(
                        icon: const Icon(
                          Icons.checklist,
                        ),
                        onPressed: () {
                          itemController.checkUncheckAllRxItem(checked: true);
                          itemController.isAllItemChecked.value = true;
                        },
                      );
                    }
                  }),
                ],
              );
            } else {
              return Container();
            }
          })
        ],
      ),
      body: Column(
        children: [
          Obx(() => itemController.isShowSearchBox.isTrue
              ? _searchBox()
              : _categorySearch()),
          FutureBuilder<List<ItemData>>(
              future: DatabaseHelper().getItem(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  itemController.setRxItem(snapshot.data!);
                  return Expanded(child: _itemList());
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const CircularProgressIndicator();
              })
        ],
      ),
      floatingActionButton: Obx(() {
        return itemController.isItemChecked.isFalse
            ? FloatingActionButton(
                backgroundColor: Colors.black87,
                child: const Icon(Icons.add),
                onPressed: () {
                  Get.to(const CreateItemPage());
                },
              )
            : Container();
      }),
    );
  }

  Widget _itemList() {
    return Obx(() => (ListView.builder(
        shrinkWrap: true,
        itemCount: itemController.lstRxItem.length,
        itemBuilder: (context, index) {
          ItemData data = itemController.lstRxItem[index];
          Uint8List decodedBytes = Uint8List(0);
          if (data.base64Photo.isNotEmpty) {
            decodedBytes = base64Decode(data.base64Photo);
          }
          return ListTile(
            leading: decodedBytes.isNotEmpty
                ? Image.memory(
                    decodedBytes,
                    width: 50,
                    height: 50,
                    fit: BoxFit.fill,
                  )
                : Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                    ),
                  ),
            title: Text(data.itemName),
            subtitle: Text(data.itemCode),
            trailing: Obx(
              () => Checkbox(
                checkColor: AppColor.accent,
                fillColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.black45),
                value: itemController.lstRxItem[index].isSelected ?? false,
                onChanged: (bool? newValue) {
                  itemController.checkUncheckRxItem(
                      index: index, checked: newValue!);
                  if (itemController.isItemChecked.isFalse) {
                    itemController.isItemChecked.value = true;
                  }

                  if (!newValue) {
                    itemController.isAllItemChecked.value = false;
                    if (!itemController.isExistCheckedRxItem()) {
                      itemController.isItemChecked.value = false;
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            onTap: () {
              Get.to(() => const CreateItemPage(), arguments: {
                "ItemID": data.itemId,
                "CategoryID": data.categoryId,
                "ItemCode": data.itemCode,
                "ItemName": data.itemName,
                "SalePrice": data.salePrice,
                "PurchasePrice": data.purchasePrice,
                "Cost": data.cost,
                "Base64Photo": data.base64Photo,
              });
            },
          );
        })));
  }

  Widget _categorySearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black12)),
            height: 60,
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: Obx(
                  () {
                    return DropdownButton(
                      value: itemController.listDefaultCatVal.value,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black87,
                      ),
                      items: itemController.lstCategoryInList.map((e) {
                        return DropdownMenuItem<CategoryData>(
                          value: e,
                          child: Text(e.categoryName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        EasyLoading.show();
                        DatabaseHelper()
                            .getItem(categoryId: value!.categoryId)
                            .then((lstItem) {
                          EasyLoading.dismiss();
                          itemController.setRxItem(lstItem);
                          itemController.listDefaultCatVal.value = value;
                        });
                      },
                      isExpanded: true,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.black12)),
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.grey, elevation: 0),
              child: const Icon(
                Icons.search,
                color: Colors.black87,
              ),
              onPressed: () {
                itemController.isShowSearchBox.value = true;
              },
            )),
      ],
    );
  }

  Widget _searchBox() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: TextField(
          onSubmitted: (value) {
            EasyLoading.show();
            DatabaseHelper().getItem(searchValue: value).then((lstItem) {
              EasyLoading.dismiss();
              itemController.setRxItem(lstItem);
            });
          },
          cursorColor: Colors.black87,
          decoration: InputDecoration(
              hintText: AppString.search,
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black87,
                ),
                onPressed: (() {
                  itemController.isShowSearchBox.value = false;
                  itemController.listDefaultCatVal.value =
                      itemController.lstCategoryInList[0];
                  EasyLoading.show();
                  DatabaseHelper().getItem().then((lstItem) {
                    EasyLoading.dismiss();
                    itemController.setRxItem(lstItem);
                  });
                }),
              ),
              border: const OutlineInputBorder(borderSide: BorderSide.none))),
    );
  }
}
