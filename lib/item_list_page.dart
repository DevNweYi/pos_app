import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/create_item_page.dart';
import 'package:pos_app/value/app_string.dart';

import 'value/app_color.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  String dropdownvalue = 'All Items';
  var categories = [
    'All Items',
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
    'Category 5',
  ];
  bool isShowSearchBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      appBar: AppBar(
        title: const Text(AppString.items),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        children: [isShowSearchBox ? _searchBox() : _categorySearch()],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(const CreateItemPage());
          }),
    );
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
                child: DropdownButton(
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down,color: Colors.black87,),
                  items: categories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropdownvalue = value!;
                    });
                  },
                  isExpanded: true,
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
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: TextField(
          cursorColor: Colors.black87,
          decoration: InputDecoration(
              hintText: AppString.search,
              suffixIcon: IconButton(
                icon: const Icon(Icons.close,color: Colors.black87,),
                onPressed: (() {
                  setState(() {
                    isShowSearchBox = false;
                  });
                }),
              ),
              border: const OutlineInputBorder(borderSide: BorderSide.none))),
    );
  }
}
