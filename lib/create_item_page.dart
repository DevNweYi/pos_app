import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/controller/item_controller.dart';
import 'package:pos_app/database/database_helper.dart';
import 'package:pos_app/value/app_color.dart';

import 'model/category_data.dart';
import 'value/app_string.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {

  var itemController=Get.put(ItemController());
  List<CategoryData> lstCategory=[];
  String dropdownvalue="";
  /* var categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
    'Category 5',
  ]; */

  @override
  void initState() {
    DatabaseHelper().getCategory().then((value) {
      setState(() {
        lstCategory=value;
        if(lstCategory.isNotEmpty){
          dropdownvalue=lstCategory[0].categoryName;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text(AppString.createItem),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.black87,
        actions: [
          TextButton(
            child: const Text(AppString.save,style: TextStyle(color: Colors.black87),),
            onPressed: () {
              
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
                Container(               
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: TextField(
                    controller: itemController.codeController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: AppString.code,
                      border: OutlineInputBorder(borderSide: BorderSide.none)
                    ),               
                  ),
                ),              
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: TextField(
                    controller: itemController.nameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: AppString.name,
                      border: OutlineInputBorder(borderSide: BorderSide.none)
                    ),               
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(5))),
                  height: 60,
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton(
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: lstCategory.map((e){
                          return DropdownMenuItem(
                              value: e.categoryId,
                              child: Text(e.categoryName),
                          );
                        }).toList(),
                        /* categories.map((String category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(), */
                        onChanged: (value) {
                          setState(() {
                            dropdownvalue = value.toString();
                          });
                        },
                        isExpanded: true,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: TextField(
                    controller: itemController.salePriceController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: AppString.salePrice,
                      border: OutlineInputBorder(borderSide: BorderSide.none)
                    ),               
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: TextField(
                    controller: itemController.purchasePriceController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: AppString.purchasePrice,
                      border: OutlineInputBorder(borderSide: BorderSide.none)
                    ),               
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black12),borderRadius: const BorderRadius.all(Radius.circular(5))),
                  child: TextField(
                    controller: itemController.costController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: AppString.cost,
                      border: OutlineInputBorder(borderSide: BorderSide.none)
                    ),               
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Image.asset(""),
                      Container(
                        color: Colors.red,
                        height: 100,
                        width: 100,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(onPressed: (){}, icon: const Icon(Icons.photo), label: const Text(AppString.choosePhoto)),
                          TextButton.icon(onPressed: (){}, icon: const Icon(Icons.photo_camera), label: const Text(AppString.takePhoto)),
                        ],
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}