import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  ItemController itemController = Get.find();
  dynamic argumentData = Get.arguments;
  List<CategoryData> lstCategory = [];
  CategoryData dropdownvalue =
      CategoryData(categoryId: 0, categoryCode: "", categoryName: "");
  dynamic imagePicker;
  dynamic _image;
  late int _itemId;
  bool _isUpdate = false;
  String _base64Photo = "";
  Uint8List _decodedBytes = Uint8List(0);

  @override
  void initState() {
    DatabaseHelper().getCategory().then((value) {
      setState(() {
        if (value.isNotEmpty) {
          dropdownvalue = value[0];
        }
        lstCategory = value;
      });
    });
    imagePicker = ImagePicker();

    if (argumentData != null) {
      _itemId = argumentData["ItemID"];
      if (_itemId != 0) {
        _isUpdate = true;
        itemController.fillData(argumentData);
        _base64Photo = argumentData["Base64Photo"];
        _decodedBytes = _decode(_base64Photo);
        int categoryId = argumentData["CategoryID"];
        for (int i = 0; i < lstCategory.length; i++) {
          if (lstCategory[i].categoryId == categoryId) {
            dropdownvalue = lstCategory[i];
            break;
          }
        }
      }
    }else{
      itemController.clearControl();
    }

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
            child: const Text(
              AppString.save,
              style: TextStyle(color: Colors.black87),
            ),
            onPressed: () {
              /* if (_image != null) {
                _base64Photo = _convertBase64Photo(_image); */
              /* final bytes = File(_image.path.toString()).readAsBytesSync();
                base64Photo = base64Encode(bytes); */
              //}
              if (!_isUpdate) {
                itemController
                    .insert(
                        categoryId: dropdownvalue.categoryId,
                        base64Photo: _base64Photo)
                    .then((value) {
                  _image = null;
                  _base64Photo = "";
                  setState(() {
                    _decodedBytes = Uint8List(0);
                  });
                });
              } else {
                itemController.updateItem(
                    itemId: _itemId,
                    categoryId: dropdownvalue.categoryId,
                    base64Photo: _base64Photo);
              }
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
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  controller: itemController.codeController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      hintText: AppString.code,
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  controller: itemController.nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      hintText: AppString.name,
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                height: 60,
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      value: dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: lstCategory.map((e) {
                        return DropdownMenuItem<CategoryData>(
                          value: e,
                          child: Text(e.categoryName),
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
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  controller: itemController.salePriceController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: AppString.salePrice,
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  controller: itemController.purchasePriceController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: AppString.purchasePrice,
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: TextField(
                  controller: itemController.costController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: AppString.cost,
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: _decodedBytes.isNotEmpty
                            ? Image.memory(
                                _decodedBytes,
                                width: 150,
                                height: 150,
                                fit: BoxFit.fitHeight,
                              )
                            : Container(
                                height: 150,
                                width: 150,
                                decoration: const BoxDecoration(
                                  color: AppColor.grey,
                                ),
                              )),
                    /* _image != null
                            ? Image.file(
                                _image,
                                width: 150,
                                height: 150,
                                fit: BoxFit.fitHeight,
                              )
                            : Container(
                                height: 150,
                                width: 150,
                                decoration: const BoxDecoration(
                                  color: AppColor.grey,
                                ),
                              )), */
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                            onPressed: () async {
                              XFile? image = await imagePicker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 50,
                                  preferredCameraDevice: CameraDevice.front);
                              if (image != null) {
                                _image = File(image.path);
                                _base64Photo = _convertBase64Photo(_image);
                                setState(() {
                                  _decodedBytes = _decode(_base64Photo);
                                });
                              }
                            },
                            icon: const Icon(Icons.photo),
                            label: const Text(AppString.choosePhoto)),
                        TextButton.icon(
                            onPressed: () async {
                              XFile? image = await imagePicker.pickImage(
                                  source: ImageSource.camera,
                                  imageQuality: 50,
                                  preferredCameraDevice: CameraDevice.front);
                              if (image != null) {
                                _image = File(image.path);
                                _base64Photo = _convertBase64Photo(_image);
                                setState(() {
                                  _decodedBytes = _decode(_base64Photo);
                                });
                              }
                            },
                            icon: const Icon(Icons.photo_camera),
                            label: const Text(AppString.takePhoto)),
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

  String _convertBase64Photo(dynamic image) {
    final bytes = File(_image.path.toString()).readAsBytesSync();
    String base64Photo = base64Encode(bytes);
    return base64Photo;
  }

  Uint8List _decode(String base64Photo) {
    Uint8List decodedBytes = base64Decode(base64Photo);
    return decodedBytes;
  }
}
