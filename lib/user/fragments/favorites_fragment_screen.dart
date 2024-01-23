// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unused_import, prefer_is_empty, use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, unnecessary_string_escapes, avoid_print

import 'dart:convert';

import 'package:magazza/user/model/goods.dart';
import 'package:magazza/user/model/favorite.dart';
import 'package:magazza/user/userPreferences/current_users.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../api_connection/api_connection.dart';
import '../item/item_details_screen.dart';
import 'package:intl/intl.dart';

class FavoritesFragmentScreen extends StatelessWidget {
  final currentOnlineUser = Get.put(CurrentUser());

  Future<List<Favorite>> getCurrentUserFavoriteList() async {
    List<Favorite> favoriteListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readFavorite), body: {
        "user_id": currentOnlineUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserFavoriteListItems = jsonDecode(res.body);

        if (responseBodyOfCurrentUserFavoriteListItems['success'] == true) {
          (responseBodyOfCurrentUserFavoriteListItems['currentUserFavoriteData']
                  as List)
              .forEach((eachCurrentUserFavoriteItemData) {
            favoriteListOfCurrentUser
                .add(Favorite.fromJson(eachCurrentUserFavoriteItemData));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }

    return favoriteListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "Favorite",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          //displaying favoriteList
          favoriteListItemDesignWidget(context),
        ],
      ),
    );
  }

  favoriteListItemDesignWidget(context) {
    return FutureBuilder(
        future: getCurrentUserFavoriteList(),
        builder: (context, AsyncSnapshot<List<Favorite>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 300),
                Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: Text(
                "Tidak ada barang",
                style: TextStyle(
                  color: Colors.grey,
                ),
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
                Favorite eachFavoriteItemRecord = dataSnapShot.data![index];

                Goods clickedGoodItem = Goods(
                  item_id: eachFavoriteItemRecord.item_id,
                  image: eachFavoriteItemRecord.image,
                  name: eachFavoriteItemRecord.name,
                  price: eachFavoriteItemRecord.price,
                  description: eachFavoriteItemRecord.description,
                  tags: eachFavoriteItemRecord.tags,
                );
                print("adt");
                return GestureDetector(
                  onTap: () {
                    Get.to(ItemsDetailsScreen(itemInfo: clickedGoodItem));
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FadeInImage(
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                            placeholder:
                                const AssetImage("images/place_holder.png"),
                            image: NetworkImage(
                              eachFavoriteItemRecord.image!,
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        eachFavoriteItemRecord.name!,
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
                                        eachFavoriteItemRecord.description!,
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
                                        "Rp. " +
                                            formatCurrency(
                                                eachFavoriteItemRecord.price ??
                                                    0),
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 300),
                Center(
                  child: Text(
                    "Tidak ada barang favorite",
                    style: TextStyle(color: Colors.grey),

                    // Jika Anda ingin menyesuaikan gaya teks atau atribut lainnya, tambahkan di sini
                  ),
                )
              ],
            );
          }
        });
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: '');
    return formatter.format(value).replaceAll(",00", "");
  }
}
