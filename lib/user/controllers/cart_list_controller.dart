// ignore_for_file: prefer_final_fields, invalid_use_of_protected_member, avoid_print, unused_import

import 'package:magazza/user/model/cart.dart';
import 'package:get/get.dart';

class CartListController extends GetxController {
  RxList<Cart> _cartlist = <Cart>[].obs; //user all items in cart + record //5
  RxList<int> _selectedItemList = <int>[]
      .obs; //user selected items for which user want to proceed and want to place final order //2
  RxBool _isSelectedAll = false.obs;
  RxDouble _total = 0.0.obs;

  List<Cart> get cartList => _cartlist.value;
  List<int> get selectedItemList => _selectedItemList.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;
  setList(List<Cart> list) {
    _cartlist.value = list;
  }

  addSelectedItem(int selectedItemCartID) {
    _selectedItemList.value.add(selectedItemCartID);
    print(selectedItemCartID);
    update();
  }

  deleteSelectedItem(int selectedItemCartID) {
    _selectedItemList.value.remove(selectedItemCartID);
    print("item select dihapus");
    update();
  }

  setIsSelectedAllItems() {
    //true
    _isSelectedAll.value = !_isSelectedAll.value;
    print("item select dipilih");
  }

  clearAllSelectedItems() {
    _selectedItemList.value.clear();
    print("item select dihapus");
    update();
  }

  setTotal(double overallTotal) {
    _total.value = overallTotal;
  }
}
