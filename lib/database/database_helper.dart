import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/category_data.dart';
import '../model/item_data.dart';

class DatabaseHelper {
  late Database _db;
  static const String categoryTableName = "Category";
  static const String itemTableName = "Item";

  Future<Database> _createDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "pos.db");
    _db = await openDatabase(path);
    await _db.execute(
        "CREATE TABLE IF NOT EXISTS $categoryTableName(CategoryID INTEGER PRIMARY KEY AUTOINCREMENT,CategoryCode TEXT,CategoryName TEXT)");
    await _db.execute(
        "CREATE TABLE IF NOT EXISTS $itemTableName(ItemID INTEGER PRIMARY KEY AUTOINCREMENT,CategoryID INTEGER,ItemCode TEXT,ItemName TEXT,SalePrice INTEGER,PurchasePrice INTEGER,Cost INTEGER,Base64Photo TEXT)");
    return _db;
  }

  Future<int> insertCategory(Map<String, dynamic> categoryData) async {
    _db = await _createDatabase();
    return await _db.insert(categoryTableName, categoryData);
  }

  Future<int> updateCategory(Map<String, dynamic> categoryData) async {
    _db = await _createDatabase();
    int categoryId = categoryData["CategoryID"];
    return await _db.update(categoryTableName, categoryData,
        where: "CategoryID=$categoryId");
  }

  Future<int> deleteCategory(List<int> lstCategoryID) async {
    _db = await _createDatabase();
    return await _db.delete(categoryTableName,
        where:
            "CategoryID IN (${List.filled(lstCategoryID.length, '?').join(',')})",
        whereArgs: lstCategoryID);
  }

  Future<List<CategoryData>> getCategory({String? searchValue}) async {
    _db = await _createDatabase();
    List<CategoryData> lstCategory = [];
    List<Map<String, dynamic>> list;

    if (searchValue == null || searchValue.isEmpty) {
      list = await _db.rawQuery(
          "SELECT CategoryID,CategoryCode,CategoryName FROM $categoryTableName");
    } else {
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

  Future<bool> isDuplicateCategoryCode(String categoryCode) async {
    _db = await _createDatabase();
    List<Map<String, dynamic>> list;
    list = await _db.rawQuery(
        "SELECT CategoryID FROM $categoryTableName WHERE CategoryCode='$categoryCode'");
    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> isDuplicateUpdateCategoryCode(
      int categoryId, String categoryCode) async {
    _db = await _createDatabase();
    List<Map<String, dynamic>> list;
    list = await _db.rawQuery(
        "SELECT CategoryID FROM $categoryTableName WHERE CategoryCode='$categoryCode' AND CategoryID!=$categoryId");
    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<int> insertItem(Map<String, dynamic> itemData) async {
    _db = await _createDatabase();
    return await _db.insert(itemTableName, itemData);
  }

   Future<int> updateItem(Map<String, dynamic> itemData) async {
    _db = await _createDatabase();
    int itemId = itemData["ItemID"];
    return await _db.update(itemTableName, itemData,
        where: "ItemID=$itemId");
  }

  Future<bool> isDuplicateItemCode(String itemCode) async {
    _db = await _createDatabase();
    List<Map<String, dynamic>> list;
    list = await _db.rawQuery(
        "SELECT ItemID FROM $itemTableName WHERE ItemCode='$itemCode'");
    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> isDuplicateUpdateItemCode(int itemId,String itemCode) async {
    _db = await _createDatabase();
    List<Map<String, dynamic>> list;
    list = await _db.rawQuery(
        "SELECT ItemID FROM $itemTableName WHERE ItemCode='$itemCode' AND ItemID!=$itemId");
    if (list.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<ItemData>> getItem({String? searchValue,int? categoryId}) async {
    _db = await _createDatabase();
    List<ItemData> lstItem = [];
    List<Map<String, dynamic>> list;

    if(categoryId != null && categoryId != 0){
      list = await _db.rawQuery(
          "SELECT ItemID,CategoryID,ItemCode,ItemName,SalePrice,PurchasePrice,Cost,Base64Photo FROM $itemTableName WHERE CategoryID=$categoryId");
    }else if(searchValue != null && searchValue.isNotEmpty){
      list = await _db.rawQuery(
          "SELECT ItemID,CategoryID,ItemCode,ItemName,SalePrice,PurchasePrice,Cost,Base64Photo FROM $itemTableName WHERE ItemName LIKE '%$searchValue%'");
    }else{
      list = await _db.rawQuery(
          "SELECT ItemID,CategoryID,ItemCode,ItemName,SalePrice,PurchasePrice,Cost,Base64Photo FROM $itemTableName");
    }

    /* if (searchValue == null || searchValue.isEmpty) {
      list = await _db.rawQuery(
          "SELECT ItemID,CategoryID,ItemCode,ItemName,SalePrice,PurchasePrice,Cost,Base64Photo FROM $itemTableName");
    } else {
      list = await _db.rawQuery(
          "SELECT ItemID,CategoryID,ItemCode,ItemName,SalePrice,PurchasePrice,Cost,Base64Photo FROM $itemTableName WHERE ItemName LIKE '%$searchValue%'");
    } */

    for (int i = 0; i < list.length; i++) {
      Map data = list[i];
      ItemData itemData = ItemData(
          itemId: data["ItemID"],
          categoryId: data["CategoryID"],
          itemCode: data["ItemCode"],
          itemName: data["ItemName"],
          salePrice: data["SalePrice"],
          purchasePrice: data["PurchasePrice"],
          cost: data["Cost"],
          base64Photo: data["Base64Photo"]);
      lstItem.add(itemData);
    }
    return lstItem;
  }

  Future<int> deleteItem(List<int> lstItemID) async {
    _db = await _createDatabase();
    return await _db.delete(itemTableName,
        where:
            "ItemID IN (${List.filled(lstItemID.length, '?').join(',')})",
        whereArgs: lstItemID);
  }
}
