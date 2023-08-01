import 'package:get/get.dart';

import '../model/category_data.dart';
import '../model/item_data.dart';

class SaleController extends GetxController{
  RxList<ItemData> lstRxItem = <ItemData>[].obs;
  Rx<CategoryData> defaultCategory =
      CategoryData(categoryId: 0, categoryCode: "", categoryName: "All Items").obs;
  RxList<CategoryData> lstCategory = <CategoryData>[].obs;
  RxBool isShowSearchBox=false.obs;

   void setRxItem(List<ItemData> lstItem) {
    lstRxItem.value = lstItem.obs;
    lstRxItem.refresh();
  }
}