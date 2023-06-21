import 'package:flutter/material.dart';
import 'package:pos_app/value/app_string.dart';

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
  bool isShowSearchBox=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.items),
      ),
      body: Column(
        children: [
          isShowSearchBox? _searchBox() : _categorySearch()],
      ),
    );
  }

  Widget _categorySearch() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black12)),
              height: 50,
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
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
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: const Icon(
                  Icons.search,
                  color: Colors.black45,
                ),
                onPressed: () {
                  setState(() {
                    isShowSearchBox=true;
                  });
                },
              )),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      color: Colors.yellow,
      child: TextField(
        decoration: InputDecoration(
            labelText: AppString.search,
            hintText: AppString.search,
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: (() {
                setState(() {
                  isShowSearchBox=false;
                });
              }),
            ),
            border: const OutlineInputBorder()),
      ),
    );
  }
}
