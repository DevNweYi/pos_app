class ItemData {
  late int itemId;
  late int categoryId;
  late String itemCode;
  late String itemName;
  late int salePrice;
  late int purchasePrice;
  late int cost;
  late String base64Photo;

  ItemData(
      {required this.itemId,
      required this.categoryId,
      required this.itemCode,
      required this.itemName,
      required this.salePrice,
      required this.purchasePrice,
      required this.cost,
      required this.base64Photo});

  static Map<String, dynamic> insertItem(
      {required int categoryId,
      required String itemCode,
      required String itemName,
      required int salePrice,
      required int purchasePrice,
      required int cost,
      required String base64Photo}) {
    return {
      "CategoryID": categoryId,
      "ItemCode": itemCode,
      "ItemName": itemName,
      "SalePrice": salePrice,
      "PurchasePrice": purchasePrice,
      "Cost": cost,
      "Base64Photo": base64Photo,
    };
  }
}
