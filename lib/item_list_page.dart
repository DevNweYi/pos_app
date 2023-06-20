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
          Container(
            //color: Colors.red,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                    //color: Colors.white,
                    height: 50,
                    child: DropdownButtonHideUnderline(
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
                  ),
                ),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: Icon(Icons.search,color: Colors.black45,),
                    onPressed: () {
                      
                    },)
                  /* OutlinedButton(
                    child: Icon(Icons.search),
                    style: OutlinedButton.styleFrom(backgroundColor: Colors.green,),
                    onPressed: () {
                      
                    },
                  ), */
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
