class CategoryData{
  late int categoryId;
  late String categoryCode;
  late String categoryName;

  CategoryData({required this.categoryId,required this.categoryCode,required this.categoryName});

  static Map<String,dynamic> insertCategory({required String categoryCode,required String categoryName}){
      return {
        "CategoryCode":categoryCode,
        "CategoryName":categoryName      
        };
  }
}