// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, unnecessary_import, unused_import, prefer_interpolation_to_compose_strings, avoid_function_literals_in_foreach_calls, avoid_print, prefer_is_empty, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:magazza/api_connection/api_connection.dart';
import 'package:magazza/user/cart/cart_list_screen.dart';
import 'package:magazza/user/item/item_details_screen.dart';
import 'package:magazza/user/item/search_items.dart';
import 'package:magazza/user/model/goods.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeFragmentScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  Future<List<Goods>> getAllCategoryItems() async {
    List<Goods> allCategoryItems = [];

    try {
      var res = await http.post(Uri.parse(API.getAllGoods));

      if (res.statusCode == 200) {
        var responseBodyOfAllGoods = jsonDecode(res.body);
        if (responseBodyOfAllGoods["success"] == true) {
          (responseBodyOfAllGoods["goodsItemsData"] as List)
              .forEach((eachRecord) {
            allCategoryItems.add(Goods.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Data error:: " + errorMsg.toString());
    }
    return allCategoryItems;
  }

  Future<List<Goods>> getAllgoodItems() async {
    List<Goods> allGoodItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.getAllGoods));

      if (res.statusCode == 200) {
        var responseBodyOfAllGoods = jsonDecode(res.body);
        if (responseBodyOfAllGoods["success"] == true) {
          (responseBodyOfAllGoods["goodsItemsData"] as List)
              .forEach((eachRecord) {
            allGoodItemsList.add(Goods.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("ErrorCoy:: " + errorMsg.toString());
    }
    return allGoodItemsList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),

          //search bar widget
          searchBarWidget(),

          const SizedBox(
            height: 5,
          ),

          allItemWidget(context),
        ],
      ),
    );
  }

  Widget searchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              Get.to(SearchItems(typedKeyWords: searchController.text));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          hintText: "Temukan apa yang kamu butuhkan",
          hintStyle: const TextStyle(
              color: Color.fromARGB(255, 134, 128, 128),
              fontSize: 14,
              fontWeight: FontWeight.normal),
          suffixIcon: IconButton(
            onPressed: () {
              Get.to(CartListScreen());
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          filled: true,
          fillColor: Colors.white,
          // Warna latar belakang
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none, // Hilangkan garis tepi
          ),
        ),
      ),
    );
  }

  Widget allItemWidget(BuildContext context) {
    return FutureBuilder<List<Goods>>(
      future: getAllgoodItems(),
      builder: (context, AsyncSnapshot<List<Goods>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return Center();
        }
        if (dataSnapShot.hasError) {
          return Center(
            child: Text(
              "Gagal memuat barang",
            ),
          );
        }
        if (dataSnapShot.data == null || dataSnapShot.data!.isEmpty) {
          return Center(
            child: Text(
              "Gagal memuat barang",
            ),
          );
        }

        return ListView.builder(
          itemCount: (dataSnapShot.data!.length / 2).ceil(),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            int firstIndex = index * 2;
            int secondIndex = index * 2 + 1;

            return Row(
              children: [
                Expanded(
                  child: buildItemCard(
                    dataSnapShot.data![firstIndex],
                  ),
                ),
                SizedBox(width: 5), // Spacer between columns
                Expanded(
                  child: secondIndex < dataSnapShot.data!.length
                      ? buildItemCard(
                          dataSnapShot.data![secondIndex],
                        )
                      : Container(), // Use an empty container if no second item
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildItemCard(Goods eachGoodItemRecord) {
    return GestureDetector(
      onTap: () {
        // Handle item tap
        Get.to(ItemsDetailsScreen(itemInfo: eachGoodItemRecord));
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          // side: BorderSide(color: Colors.black, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: FadeInImage(
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: const AssetImage("images/place_holder.png"),
                image: NetworkImage(eachGoodItemRecord.image ?? ""),
                imageErrorBuilder: (context, error, stackTraceError) {
                  return const Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eachGoodItemRecord.name ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Rp. " + formatCurrency(eachGoodItemRecord.price ?? 0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
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
