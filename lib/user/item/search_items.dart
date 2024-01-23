// ignore_for_file: unused_import, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_import, prefer_interpolation_to_compose_strings, prefer_is_empty, avoid_function_literals_in_foreach_calls, unnecessary_string_escapes

import 'dart:convert';

import 'package:magazza/user/model/goods.dart';
import 'package:magazza/user/item/item_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../api_connection/api_connection.dart';
import '../cart/cart_list_screen.dart';
import 'package:http/http.dart' as http;

class SearchItems extends StatefulWidget {
  final String? typedKeyWords;
  SearchItems({
    this.typedKeyWords,
  });
  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  TextEditingController searchController = TextEditingController();
  Future<List<Goods>> readSearchRecordsFound() async {
    List<Goods> goodsSearchList = [];

    if (searchController.text != "") {
      try {
        var res = await http.post(Uri.parse(API.searchItems), body: {
          "typedKeyWords": searchController.text,
        });

        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          if (responseBodyOfSearchItems['success'] == true) {
            (responseBodyOfSearchItems['itemsFoundData'] as List)
                .forEach((eachItemData) {
              goodsSearchList.add(Goods.fromJson(eachItemData));
            });
          }
        } else {
          Fluttertoast.showToast(msg: "Status Code is not 200");
        }
      } catch (errorMsg) {
        Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
      }
    }

    return goodsSearchList;
  }

  @override
  void initState() {
    super.initState();

    searchController.text = widget.typedKeyWords!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: searchItemDesignWidget(context),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          hintText: "Temukan apa yang kamu butuhkan",
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
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
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none, // Hilangkan garis tepi
          ),
        ),
      ),
    );
  }

  searchItemDesignWidget(context) {
    return FutureBuilder(
        future: readSearchRecordsFound(),
        builder: (context, AsyncSnapshot<List<Goods>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: Text(
                "No Trending item found",
              ),
            );
          }
          if (dataSnapShot.data!.length > 0) {
            return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Goods eachGoodItemRecord = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    Get.to(ItemsDetailsScreen(itemInfo: eachGoodItemRecord));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      16,
                      index == 0 ? 8 : 4,
                      16,
                      index == dataSnapShot.data!.length - 1 ? 8 : 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
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
                        //name + price
                        //tags
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FadeInImage(
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                            placeholder:
                                const AssetImage("images/place_holder.png"),
                            image: NetworkImage(
                              eachGoodItemRecord.image!,
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //name and price
                                Row(
                                  children: [
                                    //name
                                    Expanded(
                                      child: Text(
                                        eachGoodItemRecord.name!,
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
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    //name
                                    Expanded(
                                      child: Text(
                                        eachGoodItemRecord.description!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    //name
                                    Expanded(
                                      child: Text(
                                        "\Rp." +
                                            eachGoodItemRecord.price
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

                        //image clothes
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Empty, No Data."),
            );
          }
        });
  }
}
