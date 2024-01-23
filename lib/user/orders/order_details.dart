// ignore_for_file: avoid_print, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_final_fields, unnecessary_string_escapes, unnecessary_null_comparison, prefer_if_null_operators

import 'dart:convert';

import 'package:magazza/api_connection/api_connection.dart';
import 'package:magazza/user/fragments/dashboard_of_fragments.dart';
import 'package:magazza/user/model/order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class OrderDetailsScreen extends StatefulWidget {
  final Order? clickedOrderInfo;

  OrderDetailsScreen({
    this.clickedOrderInfo,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  RxString _status = "new".obs;
  String get status => _status.value;

  updateParcelStatusForUI(String parcelReceived) {
    _status.value = parcelReceived;
  }

  showDialogForParcelConfirmation() async {
    if (widget.clickedOrderInfo!.status == "new") {
      var response = await Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Konfirmasi",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: const Text(
            "Apakah sudah menerima pesanannya?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "Tidak",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: "yesConfirmed");
              },
              child: const Text(
                "Iya",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );

      if (response == "yesConfirmed") {
        updateStatusValueInDatabase();
        Get.to(DashboardOfFragments());
      }
    }
  }

  updateStatusValueInDatabase() async {
    try {
      var response = await http.post(Uri.parse(API.updateStatus), body: {
        "order_id": widget.clickedOrderInfo!.order_id.toString(),
      });

      if (response.statusCode == 200) {
        var responseBodyOfUpdateStatus = jsonDecode(response.body);

        if (responseBodyOfUpdateStatus["success"] == true) {
          updateParcelStatusForUI("arrived");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    updateParcelStatusForUI(widget.clickedOrderInfo!.status.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
        title: Text(
          DateFormat("dd MMMM, yyyy - hh:mm a")
              .format(widget.clickedOrderInfo!.dateTime!),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //display items belongs to clicked order
              displayClickedOrderItems(),

              const SizedBox(
                height: 16,
              ),

              //phoneNumber
              //showInfoCard("Data Pengirim", widget.clickedUserInfo!.user_name),

              //Shipment Address
              showInfoCard(
                  "Alamat", widget.clickedOrderInfo!.phoneNumber.toString()),

              //delivery
              // showInfoCard("Delivery System:",
              //     widget.clickedOrderInfo!.deliverySystem.toString()),

              //total amount
              showInfoCard(
                  "Ringkasan Pembayaran",
                  widget.clickedOrderInfo!.totalAmount
                      .toString()
                      .replaceAll(".0", "")),
              //note
              //payment
              showInfoCard("Metode Pembayaran",
                  widget.clickedOrderInfo!.paymentSystem.toString()),

              showInfoCard(
                "Catatan",
                widget.clickedOrderInfo?.note?.toString().isNotEmpty == true
                    ? widget.clickedOrderInfo!.note.toString()
                    : "-",
              ),

              const SizedBox(
                height: 16,
              ),

              Material(
                elevation: 4,
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: () {
                    if (status == "new") {
                      showDialogForParcelConfirmation();
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: const Text(
                      "Pesanan di terima",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              //payment proof
              // showProofOfPaymentCard("Proof of Payment/Transaction:",
              //     widget.clickedOrderInfo!.image.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget showTitleText(String titleText) {
    return Text(
      titleText,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black,
      ),
    );
  }

  Widget showContentText(String contentText) {
    return Text(
      contentText,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
      ),
    );
  }

  Widget showInfoCard(String title, String content) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 90, // Sesuaikan dengan tinggi yang diinginkan
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showTitleText(title),
              const SizedBox(height: 6),
              showContentText(content),
            ],
          ),
        ),
      ),
    );
  }

  // Widget showProofOfPaymentCard(String title, String imageUrl) {
  //   return SizedBox(
  //     height: 150, // Sesuaikan dengan tinggi yang diinginkan
  //     child: Card(
  //       elevation: 2,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(15),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             showTitleText(title),
  //             const SizedBox(height: 8),
  //             FadeInImage(
  //               width: MediaQuery.of(context).size.width * 0.8,
  //               fit: BoxFit.fitWidth,
  //               placeholder: const AssetImage("images/place_holder.png"),
  //               image: NetworkImage(
  //                 API.hostImages + imageUrl,
  //               ),
  //               imageErrorBuilder: (context, error, stackTraceError) {
  //                 return const Center(
  //                   child: Icon(
  //                     Icons.broken_image_outlined,
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget displayClickedOrderItems() {
    List<String> clickedOrderItemsInfo =
        widget.clickedOrderInfo!.selectedItems!.split("||");

    return Column(
      children: List.generate(clickedOrderItemsInfo.length, (index) {
        Map<String, dynamic> itemInfo =
            jsonDecode(clickedOrderItemsInfo[index]);

        return Container(
          width: MediaQuery.of(context)
              .size
              .width, // Menggunakan lebar penuh layar
          margin: EdgeInsets.fromLTRB(
            16,
            index == 0 ? 16 : 8,
            16,
            index == clickedOrderItemsInfo.length - 1 ? 16 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              // name + price
              // tags
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  width: 50, // Lebar gambar
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage("images/place_holder.png"),
                  image: NetworkImage(
                    itemInfo["image"],
                  ),
                  imageErrorBuilder: (context, error, stackTraceError) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // name and price
                      Row(
                        children: [
                          // name
                          Expanded(
                            child: Text(
                              itemInfo["quantity"].toString() +
                                  " x " +
                                  itemInfo["name"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // name and price

                      Row(
                        children: [
                          // name
                          Expanded(
                            child: Text(
                              "\Rp." +
                                  itemInfo["totalAmount"]
                                      .toString()
                                      .replaceAll(".0", ""),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
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
        );
      }),
    );
  }
}
