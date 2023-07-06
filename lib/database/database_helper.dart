import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/category_data.dart';

class DatabaseHelper {
  late Database _db;
  static const String categoryTableName = "Category";
  static const String productTableName = "Product";

  Future<Database> _createDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "pos.db");
    _db = await openDatabase(path);
    await _db.execute(
        "CREATE TABLE IF NOT EXISTS $categoryTableName(CategoryID INTEGER PRIMARY KEY AUTOINCREMENT,CategoryCode TEXT,CategoryName TEXT)");
    await _db.execute(
        "CREATE TABLE IF NOT EXISTS $productTableName(ProductID INTEGER,CategoryID INTEGER,ProductCode TEXT,ProductName TEXT,SalePrice INTEGER,PurchasePrice INTEGER,Cost INTEGER,Photo TEXT)");
    return _db;
  }

  Future<int> insertCategory(Map<String, dynamic> categoryData) async {
    _db = await _createDatabase();
    return await _db.insert(categoryTableName, categoryData);
  }

  Future<int> updateCategory(Map<String, dynamic> categoryData) async {
    _db = await _createDatabase();
    int categoryId=categoryData["CategoryID"];
    return await _db.update(categoryTableName, categoryData, where: "CategoryID=$categoryId");
  }

  Future<List<CategoryData>> getCategory({String? searchValue}) async {
    _db = await _createDatabase();
    List<CategoryData> lstCategory = [];
    List<Map<String, dynamic>> list;

    if(searchValue == null || searchValue.isEmpty){
        list = await _db.rawQuery(
        "SELECT CategoryID,CategoryCode,CategoryName FROM $categoryTableName");
    }else{
        list = await _db.rawQuery(
        "SELECT CategoryID,CategoryCode,CategoryName FROM $categoryTableName WHERE CategoryName LIKE '%$searchValue%'");
    }
    
    for (int i = 0; i < list.length; i++) {
      Map data = list[i];
      CategoryData categoryData = CategoryData(
          categoryId: data["CategoryID"],
          categoryCode: data["CategoryCode"],
          categoryName: data["CategoryName"]);
      lstCategory.add(categoryData);
    }
    return lstCategory;
  }

  Future<bool> isDuplicateCategoryCode(String categoryCode) async{
    _db = await _createDatabase();
    List<Map<String, dynamic>> list;
    list = await _db.rawQuery(
        "SELECT CategoryID FROM $categoryTableName WHERE CategoryCode=$categoryCode");
    if(list.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  Future<bool> isDuplicateUpdateCategoryCode(int categoryId,String categoryCode) async{
    _db = await _createDatabase();
    List<Map<String, dynamic>> list;
    list = await _db.rawQuery(
        "SELECT CategoryID FROM $categoryTableName WHERE CategoryCode=$categoryCode AND CategoryID!=$categoryId");
    if(list.isEmpty){
      return false;
    }else{
      return true;
    }
  }

}
