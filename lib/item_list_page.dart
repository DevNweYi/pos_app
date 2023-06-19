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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.items),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton(
                  value: dropdownvalue,
                  icon: const Icon(Icons.keyboard_arrow_down), 
                  items: categories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {},
                  isExpanded: true,
                ),
              ),
              OutlinedButton(
                child: Icon(Icons.search),
                onPressed: () {
                  
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
