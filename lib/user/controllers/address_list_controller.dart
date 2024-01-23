// ignore_for_file: prefer_final_fields, invalid_use_of_protected_member, avoid_print

import 'package:magazza/user/model/address.dart';
import 'package:get/get.dart';

class AddressListController extends GetxController {
  RxList<Address> _addreslist = <Address>[].obs;

  RxDouble _total = 0.0.obs;

  List<Address> get cartList => _addreslist.value;
  double get total => _total.value;

  setList(List<Address> list) {
    _addreslist.value = list;
  }

  setTotal(double overallTotal) {
    _total.value = overallTotal;
  }
}
