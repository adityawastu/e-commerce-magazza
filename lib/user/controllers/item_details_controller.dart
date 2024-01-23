// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class ItemDetailsController extends GetxController {
  RxInt _quantityItem = 1.obs;
  RxInt _sizesItem = 0.obs;
  RxBool _isFavorite = false.obs;

  int get quantity => _quantityItem.value;
  int get sizes => _sizesItem.value;
  bool get isFavorite => _isFavorite.value;

  setQuantityItem(int quantityOfItem) {
    _quantityItem.value = quantityOfItem;
  }

  setSizesItem(int sizesOfItem) {
    _sizesItem.value = sizesOfItem;
  }

  setIsFavorite(bool isFavorite) {
    _isFavorite.value = isFavorite;
  }
}
