import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_app/create_category_page.dart';
import 'package:pos_app/database/database_helper.dart';
import 'package:pos_app/value/app_string.dart';

import 'model/category_data.dart';
import 'value/app_color.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text(AppString.categories);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.grey,
        appBar: AppBar(
            title: customSearchBar,
            backgroundColor: AppColor.primary,
            foregroundColor: Colors.black87,
            actions: [
              IconButton(
                icon: customIcon,
                onPressed: (() {
                  setState(() {
                    if (customIcon.icon == Icons.search) {
                      customIcon = const Icon(Icons.close);
                      customSearchBar = const ListTile(
                        leading: Icon(
                          Icons.search,
                        ),
                        title: TextField(
                          decoration: InputDecoration(
                              hintText: AppString.search,
                              border: InputBorder.none),
                          style: TextStyle(color: Colors.black87),
                          cursorColor: Colors.black87,
                        ),
                      );
                    } else {
                      customIcon = const Icon(Icons.search);
                      customSearchBar = const Text(AppString.categories);
                    }
                  });
                }),
              )
            ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          child: const Icon(Icons.add),
          onPressed: () {
            Get.to(const CreateCategoryPage());
          },
        ),
        body: FutureBuilder<List<CategoryData>>(
          future: DatabaseHelper().getCategory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _categoryList(snapshot.data!);
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return CircularProgressIndicator();
          },
        ));
  }

  Widget _categoryList(List<CategoryData> lstCategory) {
    return ListView.builder(
        itemCount: lstCategory.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.category),
            title: Text(lstCategory[index].categoryName),
            subtitle: Text("0 Items"),
          );
        });
  }
}
