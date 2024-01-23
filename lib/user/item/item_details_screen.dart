// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_string_escapes, avoid_print, avoid_unnecessary_containers, unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:magazza/api_connection/api_connection.dart';
import 'package:magazza/user/fragments/dashboard_of_fragments.dart';
import 'package:magazza/user/fragments/home_fragment_screen.dart';
import 'package:magazza/user/model/goods.dart';
import 'package:magazza/user/controllers/item_details_controller.dart';
import 'package:magazza/user/cart/cart_list_screen.dart';
import 'package:http/http.dart' as http;
import 'package:magazza/user/userPreferences/current_users.dart';
import 'package:intl/intl.dart';

class ItemsDetailsScreen extends StatefulWidget {
  final Goods? itemInfo;

  ItemsDetailsScreen({
    this.itemInfo,
  });

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();
}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {
  final itemDetailsController = Get.put(ItemDetailsController());
  final currentOnlineUser = Get.put(CurrentUser());

  addItemToCart() async {
    try {
      var res = await http.post(
        Uri.parse(API.addToCart),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
          "quantity": itemDetailsController.quantity.toString(),
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfAddCart = jsonDecode(res.body);
        if (resBodyOfAddCart['success'] == true) {
          Fluttertoast.showToast(msg: "Item berhasil ditambahkan");
          itemDetailsController.setQuantityItem(1);
          Future.delayed(Duration(seconds: 1), () {
            Get.to(DashboardOfFragments());
          });
        } else {
          Fluttertoast.showToast(
              msg: "Error Occur. Item not saved to Cart and Try Again.");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  validateFavoriteList() async {
    try {
      var res = await http.post(
        Uri.parse(API.validateFavorite),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
        },
      );

      if (res.statusCode ==
          200) //from flutter app the connection with api to server - success
      {
        var resBodyOfValidateFavorite = jsonDecode(res.body);
        if (resBodyOfValidateFavorite['favoriteFound'] == true) {
          itemDetailsController.setIsFavorite(true);
        } else {
          itemDetailsController.setIsFavorite(false);
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  addItemToFavoriteList() async {
    try {
      var res = await http.post(
        Uri.parse(API.addFavorite),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
        },
      );

      if (res.statusCode ==
          200) //from flutter app the connection with api to server - success
      {
        var resBodyOfAddFavorite = jsonDecode(res.body);
        if (resBodyOfAddFavorite['success'] == true) {
          Fluttertoast.showToast(msg: "Item berhasil ditambahkan.");

          validateFavoriteList();
        } else {
          Fluttertoast.showToast(msg: "Item tidak berhasil ditambahkan.");
        }
      } else {
        Fluttertoast.showToast(msg: "error 200");
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  deleteItemFromFavoriteList() async {
    try {
      var res = await http.post(
        Uri.parse(API.deleteFavorite),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.itemInfo!.item_id.toString(),
        },
      );

      if (res.statusCode ==
          200) //from flutter app the connection with api to server - success
      {
        var resBodyOfDeleteFavorite = jsonDecode(res.body);
        if (resBodyOfDeleteFavorite['success'] == true) {
          Fluttertoast.showToast(msg: "item Deleted from your Favorite List.");

          validateFavoriteList();
        } else {
          Fluttertoast.showToast(
              msg: "item NOT Deleted from your Favorite List.");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print("Error :: " + errorMsg.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    validateFavoriteList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //item in image
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage("images/place_holder.png"),
            image: NetworkImage(widget.itemInfo!.image!),
            imageErrorBuilder: (context, error, stackTraceError) {
              return const Center(
                child: Icon(
                  Icons.broken_image_outlined,
                ),
              );
            },
          ),

          //item information
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  //back
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),

                  const Spacer(),

                  //favorite
                  Obx(() => IconButton(
                        onPressed: () {
                          if (itemDetailsController.isFavorite == true) {
                            //delete item from favorites
                            deleteItemFromFavoriteList();
                          } else {
                            //save item to user favorites
                            addItemToFavoriteList();
                          }
                        },
                        icon: Icon(
                          itemDetailsController.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Colors.black,
                        ),
                      )),

                  //shopping cart icon
                  IconButton(
                    onPressed: () {
                      Get.to(CartListScreen());
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  itemInfoWidget() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.5,
      width: MediaQuery.of(Get.context!).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            //name

            Text(
              widget.itemInfo!.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemInfo!.description!
                            .toString()
                            .replaceAll("[", "")
                            .replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                //quantity item counter
              ],
            ),
            // const SizedBox(height: 15),
            // const Text(
            //   "Ukuran",
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Colors.black,
            //     fontWeight: FontWeight.normal,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // Wrap(
            //   runSpacing: 8,
            //   spacing: 8,
            //   children: List.generate(widget.itemInfo!.size!.length, (index) {
            //     return Obx(
            //       () => GestureDetector(
            //         onTap: () {
            //           itemDetailsController.setSizesItem(index);
            //         },
            //         child: Container(
            //           height: 35,
            //           width: 60,
            //           decoration: BoxDecoration(
            //             border: Border.all(
            //               width: 2,
            //               color: itemDetailsController.sizes == index
            //                   ? Colors.transparent
            //                   : Colors.white,
            //             ),
            //             color: itemDetailsController.sizes == index
            //                 ? Colors.yellow
            //                 : Colors.white,
            //           ),
            //           alignment: Alignment.center,
            //           child: Text(
            //             widget.itemInfo!.size![index]
            //                     .replaceAll("[", "")
            //                     .replaceAll("]", "") +
            //                 " gr",
            //             style: TextStyle(
            //               fontSize: 16,
            //               color: Colors.black,
            //             ),
            //           ),
            //         ),
            //       ),
            //     );
            //   }),
            // ),

            const SizedBox(height: 15),

            const Text(
              "Harga",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "Rp. " + formatCurrency(widget.itemInfo!.price ?? 0),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Obx(
                        () => Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //+
                            IconButton(
                              onPressed: () {
                                itemDetailsController.setQuantityItem(
                                    itemDetailsController.quantity + 1);
                              },
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              itemDetailsController.quantity.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //-
                            IconButton(
                              onPressed: () {
                                if (itemDetailsController.quantity - 1 >= 1) {
                                  itemDetailsController.setQuantityItem(
                                      itemDetailsController.quantity - 1);
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Jumlah harus 1",
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 110),
            //add to cart button

            Material(
              elevation: 4,
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  addItemToCart();
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    "Tambahkan",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
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
