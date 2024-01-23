// ignore_for_file: prefer_is_empty, prefer_interpolation_to_compose_strings, avoid_print, avoid_function_literals_in_foreach_calls, prefer_final_fields, use_key_in_widget_constructors, must_be_immutable, unused_import, depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:typed_data';

import 'package:magazza/api_connection/api_connection.dart';
import 'package:magazza/user/fragments/dashboard_of_fragments.dart';
import 'package:magazza/user/fragments/home_fragment_screen.dart';
import 'package:magazza/user/model/order.dart';
import 'package:magazza/user/userPreferences/current_users.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final List<int>? selectedCartIDs;
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final String? deliverySystem;
  final String? paymentSystem;
  final String? phoneNumber;
  final String? shipmentAddress;
  final String? note;

  OrderConfirmationScreen({
    this.selectedCartIDs,
    this.selectedCartListItemsInfo,
    this.totalAmount,
    this.deliverySystem,
    this.paymentSystem,
    this.phoneNumber,
    this.shipmentAddress,
    this.note,
  });

  RxList<int> _imageSelectedByte = <int>[].obs;
  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);

  RxString _imageSelectedName = "".obs;
  String get imageSelectedName => _imageSelectedName.value;

  final ImagePicker _picker = ImagePicker();

  CurrentUser currentUser = Get.put(CurrentUser());

  setSelectedImage(Uint8List selectedImage) {
    _imageSelectedByte.value = selectedImage;
  }

  setSelectedImageName(String selectedImageName) {
    _imageSelectedName.value = selectedImageName;
  }

  chooseImageFromGallery() async {
    final pickedImageXFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImageXFile != null) {
      final bytesOfImage = await pickedImageXFile.readAsBytes();

      setSelectedImage(bytesOfImage);
      setSelectedImageName(path.basename(pickedImageXFile.path));
    }
  }

  saveNewOrderInfo() async {
    String selectedItemsString = selectedCartListItemsInfo!
        .map((eachSelectedItem) => jsonEncode(eachSelectedItem))
        .toList()
        .join("||");

    Order order = Order(
      order_id: 1,
      user_id: currentUser.user.user_id,
      selectedItems: selectedItemsString,
      deliverySystem: deliverySystem,
      paymentSystem: paymentSystem,
      note: note,
      totalAmount: totalAmount,
      image: DateTime.now().millisecondsSinceEpoch.toString() +
          "-" +
          imageSelectedName,
      status: "new",
      dateTime: DateTime.now(),
      shipmentAddress: shipmentAddress,
      phoneNumber: phoneNumber,
    );

    try {
      var res = await http.post(
        Uri.parse(API.addOrder),
        body: order.toJson(base64Encode(imageSelectedByte)),
      );

      if (res.statusCode == 200) {
        var responseBodyOfAddNewOrder = jsonDecode(res.body);

        if (responseBodyOfAddNewOrder["success"] == true) {
          //delete selected items from user cart
          selectedCartIDs!.forEach((eachSelectedItemCartID) {
            deleteSelectedItemsFromUserCartList(eachSelectedItemCartID);
          });
        } else {
          Fluttertoast.showToast(
              msg: "Error:: \nyour new order do NOT placed.");
        }
      }
    } catch (erroeMsg) {
      Fluttertoast.showToast(msg: "Error: " + erroeMsg.toString());
    }
  }

  deleteSelectedItemsFromUserCartList(int cartID) async {
    try {
      var res = await http
          .post(Uri.parse(API.deleteSelectedItemsFromCartList), body: {
        "cart_id": cartID.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyFromDeleteCart = jsonDecode(res.body);

        if (responseBodyFromDeleteCart["success"] == true) {
          Fluttertoast.showToast(
              msg: "your new order has been placed Successfully.");

          Get.to(DashboardOfFragments());
        }
      } else {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    } catch (errorMessage) {
      print("Error: " + errorMessage.toString());

      Fluttertoast.showToast(msg: "Error: " + errorMessage.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //image
            // Image.asset(
            //   "images/transaction.png",
            //   width: 160,
            // ),

            const SizedBox(
              height: 70,
            ),

            //title
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Silahkan upload bukti pembayaran anda",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey, // You can customize the shadow color
                    blurRadius: 0.1, // Adjust the blur radius as needed
                    spreadRadius: 0.1, // Adjust the spread radius as needed
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                'BRI',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(width: 40),
                              Expanded(
                                child: Text(
                                  "020601000100532",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Mandiri',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(width: 13),
                              Expanded(
                                child: Text(
                                  "020601000100532",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.start,
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
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(15),
              //   color: Colors.white,
              //   boxShadow: const [
              //     BoxShadow(
              //       offset: Offset(0, 0),
              //       blurRadius: 1,
              //       color: Colors.white10,
              //     ),
              //   ],
              // ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Total Tagihan',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Rp. " + formatCurrency(totalAmount ?? 0),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.end,
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
            //display selected image by user
            const SizedBox(height: 16),

            Obx(
              () => ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 1.1,
                  maxHeight: MediaQuery.of(context).size.width * 1,
                ),
                child: imageSelectedByte.length > 0
                    ? Image.memory(
                        imageSelectedByte,
                        fit: BoxFit.contain,
                      )
                    : Center(
                        child: InkWell(
                          onTap: () {
                            // Aksi yang akan dijalankan ketika ikon diklik
                            // Misalnya, tampilkan dialog, navigasi, atau lakukan tindakan lainnya.
                            chooseImageFromGallery();
                          },
                          child: Icon(
                            Icons.upload_file,
                            size: 45,
                            // Pengaturan warna ikon, ukuran, dll. dapat ditambahkan di sini
                          ),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //select image btn
                  // Material(
                  //   elevation: 8,
                  //   color: Colors.grey,
                  //   borderRadius: BorderRadius.circular(10),
                  //   child: InkWell(
                  //     onTap: () {
                  //       chooseImageFromGallery();
                  //     },
                  //     borderRadius: BorderRadius.circular(10),
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 30,
                  //         vertical: 12,
                  //       ),
                  //       child: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Icon(
                  //             Icons.photo,
                  //             color: Colors.white,
                  //             size: 24,
                  //           ),
                  //           const SizedBox(width: 8),
                  //           Text(
                  //             "Select Image",
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 16,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),

                  //confirm and proceed
                  Obx(() => Material(
                        elevation: 4,
                        color: imageSelectedByte.length > 0
                            ? Colors
                                .grey //buat ubah warna sesuai dengan kondisi
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            if (imageSelectedByte.length >= 0) {
                              //save order info
                              saveNewOrderInfo();
                            } else {
                              Fluttertoast.showToast(
                                msg: "Tolong upload bukti transfer",
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                              vertical: 12,
                            ),
                            child: Text(
                              "Confirmed & Proceed",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: '');
    return formatter.format(value).replaceAll(",00", "");
  }
}
