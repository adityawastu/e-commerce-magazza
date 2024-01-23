// ignore_for_file: prefer_final_fields

import 'package:get/get.dart';

class OrderNowController extends GetxController {
  RxString _deliverySystem = "Layanan Antar Magazza".obs;
  RxString _paymentSystem = "Bank Rakyat Indonesia".obs;

  String get deliverySys => _deliverySystem.value;
  String get paymentSys => _paymentSystem.value;

  setDeliverySystem(String newDeliverySystem) {
    _deliverySystem.value = newDeliverySystem;
  }

  setPaymentSystem(String newPaymentSystem) {
    _paymentSystem.value = newPaymentSystem;
  }
}
