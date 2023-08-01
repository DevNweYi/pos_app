import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pos_app/nav_drawer.dart';
import 'package:pos_app/value/app_color.dart';
import 'package:pos_app/value/app_string.dart';

import 'controller/sale_controller.dart';
import 'database/database_helper.dart';
import 'model/category_data.dart';
import 'model/item_data.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  var saleController = Get.put(SaleController());

  @override
  void initState() {
    EasyLoading.show();
    DatabaseHelper().getCategory().then((value) {
      EasyLoading.dismiss();
      if (value.isNotEmpty) {
        saleController.lstCategory.value = value;
        saleController.lstCategory
            .insert(0, saleController.defaultCategory.value);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text(AppString.sale),
        foregroundColor: Colors.black87,
        backgroundColor: AppColor.primary,
      ),
      body: Column(
        children: [
          Obx(() => saleController.isShowSearchBox.isTrue
              ? _searchBox()
              : _categorySearch()),
          FutureBuilder<List<ItemData>>(
              future: DatabaseHelper().getItem(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  saleController.setRxItem(snapshot.data!);
                  return Expanded(child: _itemList());
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const CircularProgressIndicator();
              })
        ],
      ),
    );
  }

  Widget _itemList() {
    return Obx(() => (ListView.builder(
        shrinkWrap: true,
        itemCount: saleController.lstRxItem.length,
        itemBuilder: (context, index) {
          ItemData data = saleController.lstRxItem[index];
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
            subtitle: Text(data.salePrice.toString()),
            onTap: () {},
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
                      value: saleController.defaultCategory.value,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.black87,
                      ),
                      items: saleController.lstCategory.map((e) {
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
                          saleController.setRxItem(lstItem);
                          saleController.defaultCategory.value = value;
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
                saleController.isShowSearchBox.value = true;
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
              saleController.setRxItem(lstItem);
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
                  saleController.isShowSearchBox.value = false;
                  saleController.defaultCategory.value =
                      saleController.lstCategory[0];
                  EasyLoading.show();
                  DatabaseHelper().getItem().then((lstItem) {
                    EasyLoading.dismiss();
                    saleController.setRxItem(lstItem);
                  });
                }),
              ),
              border: const OutlineInputBorder(borderSide: BorderSide.none))),
    );
  }
}
