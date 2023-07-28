import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pos_app/create_item_page.dart';
import 'package:pos_app/database/database_helper.dart';
import 'package:pos_app/value/app_string.dart';
import 'package:pos_app/widget/search_box.dart';

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
  bool isShowSearchBox = false,
      _isItemChecked = false,
      _isAllItemChecked = false;

  @override
  void initState() {
    EasyLoading.show();
    DatabaseHelper().getCategory().then((value) {
      EasyLoading.dismiss();
      if (value.isNotEmpty) {
        itemController.lstCategory.value = value;
        itemController.lstCategory
            .insert(0, itemController.dropdownvalue.value);
      }
    });
    /* DatabaseHelper().getItem().then((value) {
      EasyLoading.dismiss();
      itemController.setRxItem(value);
      /* setState(() {
        _itemList();
      }); */
    }); */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: !_isItemChecked
          ? AppBar(
              title: const Text(AppString.items),
              backgroundColor: AppColor.primary,
              foregroundColor: Colors.black87,
            )
          : _deleteAppBar(),
      body: Column(
        children: [
          isShowSearchBox ? _searchBox() : _categorySearch(),
          //Expanded(child: _itemList()),
          FutureBuilder<List<ItemData>>(
            future: DatabaseHelper().getItem(),
            builder: (context,snapshot){
                if(snapshot.hasData){
                  //itemController.lstRxItem.value=snapshot.data!;
                    itemController.setRxItem(snapshot.data!);
                    return Expanded(child: _itemList());
                }else if(snapshot.hasError){
                    return Text(snapshot.error.toString());
                }
                return const CircularProgressIndicator();
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(const CreateItemPage());
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
                  if (!_isItemChecked) {
                    setState(() {
                      _isItemChecked = true;
                    });
                  }

                  if (!newValue) {
                    if (!itemController.isExistCheckedRxItem()) {
                      setState(() {
                        _isItemChecked = false;
                      });
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
                      value: itemController.dropdownvalue.value,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black87,
                      ),
                      items: itemController.lstCategory.map((e) {
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
                          itemController.dropdownvalue.value = value;
                          /* setState(() {
                          dropdownvalue = value;
                          _itemList();
                        }); */
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
                setState(() {
                  isShowSearchBox = true;
                });
              },
            )),
      ],
    );
  }

  Widget _searchBox() {
    return SearchBox(
        iconButton: IconButton(
            onPressed: () {
              setState(() {
                isShowSearchBox = false;
              });
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black87,
            )));
  }

  /* Widget _searchBox() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: TextField(
          cursorColor: Colors.black87,
          decoration: InputDecoration(
              hintText: AppString.search,
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black87,
                ),
                onPressed: (() {
                  setState(() {
                    isShowSearchBox = false;
                  });
                }),
              ),
              border: const OutlineInputBorder(borderSide: BorderSide.none))),
    );
  } */

  PreferredSizeWidget _deleteAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          itemController.checkUncheckAllRxItem(checked: false);
          setState(() {
            _isItemChecked = false;
          });
        },
      ),
      title: Obx(() => Text(itemController.getCheckedRxItem().toString())),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            itemController.deleteItem().then((value) {
              if (value) {
                setState(() {
                  _isItemChecked = false;
                  _isAllItemChecked = false;
                });
              }
            });
          },
        ),
        !_isAllItemChecked
            ? IconButton(
                icon: const Icon(
                  Icons.checklist,
                ),
                onPressed: () {
                  itemController.checkUncheckAllRxItem(checked: true);
                  setState(() {
                    _isAllItemChecked = true;
                  });
                },
              )
            : IconButton(
                icon: const Icon(
                  Icons.checklist,
                  color: AppColor.accent,
                ),
                onPressed: () {
                  itemController.checkUncheckAllRxItem(checked: false);
                  _isAllItemChecked = false;
                  setState(() {
                    _isAllItemChecked = false;
                  });
                },
              )
      ],
    );
  }
}
