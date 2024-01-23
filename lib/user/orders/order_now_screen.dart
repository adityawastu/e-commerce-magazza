// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, unused_import, prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_escapes, unused_local_variable, non_constant_identifier_names, avoid_unnecessary_containers, avoid_function_literals_in_foreach_calls, prefer_is_empty, unnecessary_null_comparison, avoid_print

import 'dart:convert';

import 'package:magazza/user/controllers/order_now_controller.dart';
import 'package:magazza/user/fragments/dashboard_of_fragments.dart';
import 'package:magazza/user/orders/order_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:magazza/api_connection/api_connection.dart';
import 'package:magazza/user/addres/user_address_screen.dart';
import 'package:magazza/user/authentication/login_screen.dart';
import 'package:magazza/user/model/order.dart';
import 'package:magazza/user/userPreferences/current_users.dart';
import 'package:magazza/user/userPreferences/user_preferences.dart';
import 'package:magazza/user/model/address.dart';

class OrderNowScreen extends StatelessWidget {
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final List<int>? selectedCartIDs;
  final _currentUser = Get.put(CurrentUser());

  OrderNowController orderNowController = Get.put(OrderNowController());
  List<String> deliverySystemNamesList = ["Layanan Antar Magazza"];
  List<String> paymentSystemNamesList = ["Tunai", "Transfer Bank"];

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController shipmentAddressController = TextEditingController();
  TextEditingController noteToSellerController = TextEditingController();

  OrderNowScreen({
    this.selectedCartListItemsInfo,
    this.totalAmount,
    this.selectedCartIDs,
  });

  Future<List<Address>> getCurrentUserAddress() async {
    List<Address> addresListOfCurrentUser = [];
    try {
      var res = await http.post(Uri.parse(API.readAddress), body: {
        "user_id": _currentUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserAddress = jsonDecode(res.body);

        if (responseBodyOfCurrentUserAddress['success'] == true) {
          (responseBodyOfCurrentUserAddress['currentUserAddressData'] as List)
              .forEach((eachCurrentUserAddress) {
            addresListOfCurrentUser
                .add(Address.fromJson(eachCurrentUserAddress));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error Profile:: " + errorMsg.toString());
    }

    return addresListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, // Warna ikon (panah)
        ),
        titleSpacing: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Alamat ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          FutureBuilder(
              future: getCurrentUserAddress(),
              builder: (context, AsyncSnapshot<List<Address>> dataSnapShot) {
                if (dataSnapShot.data!.length > 0) {
                  return ListView.builder(
                      itemCount: dataSnapShot.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        Address eachAddressItemRecord =
                            dataSnapShot.data![index];
                        return Container(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                              20,
                              index == 0 ? 8 : 4,
                              20,
                              index == dataSnapShot.data!.length - 1 ? 8 : 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.transparent,
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 30,
                                  color: Color.fromARGB(255, 240, 239, 239),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                eachAddressItemRecord
                                                    .receiver_address!,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return Container(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromRGBO(245, 245, 245, 1.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Alamat tidak ditemukan',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Produk',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          displaySelectedItemsFromUserCart(),

          const SizedBox(height: 30),

          //payment system
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: paymentSystemNamesList.map((paymentSystemName) {
                return Obx(() => RadioListTile<String>(
                      tileColor: Colors.transparent,
                      dense: true,
                      activeColor: Colors.black,
                      title: Text(
                        paymentSystemName,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      value: paymentSystemName,
                      groupValue: orderNowController.paymentSys,
                      onChanged: (newPaymentSystemValue) {
                        orderNowController
                            .setPaymentSystem(newPaymentSystemValue!);
                      },
                    ));
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Ringkasan Belanja',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Subtotal di sebelah kiri
                Text(
                  "Subtotal",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                // Total amount di sebelah kanan
                Text(
                  "\Rp" + formatCurrency(totalAmount ?? 0),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Catatan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(color: Colors.black, fontSize: 14),
              controller: noteToSellerController,
              decoration: InputDecoration(
                hintText: 'Tulis catatan Disini',
                hintStyle: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          //pay amount now btn
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  if (orderNowController.paymentSys == "Tunai") {
                    OrderConfirmationScreen(
                      selectedCartIDs: selectedCartIDs,
                      selectedCartListItemsInfo: selectedCartListItemsInfo,
                      totalAmount: totalAmount,
                      deliverySystem: orderNowController.deliverySys,
                      paymentSystem: orderNowController.paymentSys,
                      phoneNumber: phoneNumberController.text,
                      shipmentAddress: shipmentAddressController.text,
                      note: noteToSellerController.text,
                    ).saveNewOrderInfo();
                  } else {
                    Get.to(OrderConfirmationScreen(
                      selectedCartIDs: selectedCartIDs,
                      selectedCartListItemsInfo: selectedCartListItemsInfo,
                      totalAmount: totalAmount,
                      deliverySystem: orderNowController.deliverySys,
                      paymentSystem: orderNowController.paymentSys,
                      phoneNumber: phoneNumberController.text,
                      shipmentAddress: shipmentAddressController.text,
                      note: noteToSellerController.text,
                    ));
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Pesan Sekarang",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  displaySelectedItemsFromUserCart() {
    return Column(
      children: List.generate(
        selectedCartListItemsInfo!.length,
        (index) {
          Map<String, dynamic> eachSelectedItem =
              selectedCartListItemsInfo![index];
          return SizedBox(
            // width: MediaQuery.of(context).size.width,
            height: 90,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        16,
                        index == 0 ? 8 : 4,
                        16,
                        index == selectedCartListItemsInfo!.length - 1 ? 8 : 4,
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FadeInImage(
                                height: 81,
                                width: 81,
                                fit: BoxFit.cover,
                                placeholder:
                                    const AssetImage("images/place_holder.png"),
                                image: NetworkImage(
                                  eachSelectedItem["image"],
                                ),
                                imageErrorBuilder:
                                    (context, error, stackTraceError) {
                                  return const Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 7, top: 27),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //name
                                  Text(
                                    eachSelectedItem["name"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      //price
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 0),
                                        child: Text(
                                          "Jumlah : " +
                                              eachSelectedItem["quantity"]
                                                  .toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //+ 2 -
                                ],
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 0),
                                child: Text(
                                  "Rp. " +
                                      formatCurrency(
                                          eachSelectedItem["totalAmount"] ?? 0),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: '');
    return formatter.format(value).replaceAll(",00", "");
  }
}
