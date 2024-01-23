// ignore_for_file: use_key_in_widget_constructors, avoid_function_literals_in_foreach_calls, prefer_interpolation_to_compose_strings, unused_import, prefer_is_empty, avoid_print, prefer_adjacent_string_concatenation, unnecessary_string_escapes, prefer_const_constructors, unused_local_variable, sort_child_properties_last

import 'dart:convert';
import 'package:magazza/api_connection/api_connection.dart';
import 'package:magazza/user/controllers/cart_list_controller.dart';
import 'package:magazza/user/controllers/address_list_controller.dart';
import 'package:magazza/user/model/cart.dart';
import 'package:magazza/user/model/goods.dart';
import 'package:magazza/user/orders/order_now_screen.dart';
import 'package:magazza/user/userPreferences/current_users.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:magazza/user/model/address.dart';

class CartListScreen extends StatefulWidget {
  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());
  final addressListController = Get.put(AddressListController());
  final double lat = -6.9730;
  final double lon = 107.6317;

  getCurrentUserAddress() async {
    List<Address> addresListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readAddress), body: {
        "user_id": currentOnlineUser.user.user_id.toString(),
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
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }
  }

  getCurrentUserCartList() async {
    List<Cart> cartListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.getCartList), body: {
        "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);

        if (responseBodyOfGetCurrentUserCartItems['success'] == true) {
          (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List)
              .forEach((eachCurrentUserCartItemData) {
            cartListOfCurrentUser
                .add(Cart.fromJson(eachCurrentUserCartItemData));
          });
        } else {
          // Fluttertoast.showToast(msg: "Error Occurred while executing query");
        }

        cartListController.setList(cartListOfCurrentUser);
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
    }
    calculateTotalAmount();
  }

  calculateTotalRange() {
    // hitung ongkos jarak
  }

  calculateTotalAmount() {
    cartListController.setTotal(0);

    if (cartListController.selectedItemList.length > 0) {
      cartListController.cartList.forEach((itemInCart) {
        if (cartListController.selectedItemList.contains(itemInCart.cart_id)) {
          double eachItemTotalAmount = (itemInCart.price!) *
              (double.parse(itemInCart.quantity.toString()));

          cartListController
              .setTotal(cartListController.total + eachItemTotalAmount);
        }
      });
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
          getCurrentUserCartList();
        }
      } else {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    } catch (errorMessage) {
      print("Error: " + errorMessage.toString());

      Fluttertoast.showToast(msg: "Error: " + errorMessage.toString());
    }
  }

  updateQuantityInUserCart(int cartID, int newQuantity) async {
    try {
      var res = await http.post(Uri.parse(API.updateItemInCartList), body: {
        "cart_id": cartID.toString(),
        "quantity": newQuantity.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfUpdateQuantity = jsonDecode(res.body);

        if (responseBodyOfUpdateQuantity["success"] == true) {
          getCurrentUserCartList();
        }
      } else {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    } catch (errorMessage) {
      print("Error: " + errorMessage.toString());

      Fluttertoast.showToast(msg: "Error: " + errorMessage.toString());
    }
  }

  List<Map<String, dynamic>> getSelectedCartListItemsInformation() {
    List<Map<String, dynamic>> selectedCartListItemsInformation = [];

    if (cartListController.selectedItemList.length > 0) {
      cartListController.cartList.forEach((selectedCartListItem) {
        if (cartListController.selectedItemList
            .contains(selectedCartListItem.cart_id)) {
          Map<String, dynamic> itemInformation = {
            "item_id": selectedCartListItem.item_id,
            "name": selectedCartListItem.name,
            'image': selectedCartListItem.image,
            'quantity': selectedCartListItem.quantity,
            'totalAmount':
                selectedCartListItem.price! * selectedCartListItem.quantity!,
            'price': selectedCartListItem.price!,
          };

          selectedCartListItemsInformation.add(itemInformation);
        }
      });
    }

    return selectedCartListItemsInformation;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
        title: const Text(
          "Keranjang Saya",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          //to select all items
          Obx(
            () => IconButton(
              onPressed: () {
                cartListController.setIsSelectedAllItems();
                cartListController.clearAllSelectedItems();

                if (cartListController.isSelectedAll) {
                  cartListController.cartList.forEach((eachItem) {
                    cartListController.addSelectedItem(eachItem.cart_id!);
                  });
                }

                calculateTotalAmount();
              },
              icon: Icon(
                cartListController.isSelectedAll
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: cartListController.isSelectedAll
                    ? Colors.black
                    : Colors.black,
              ),
            ),
          ),

          //to delete selected item/items
          GetBuilder(
              init: CartListController(),
              builder: (c) {
                if (cartListController.selectedItemList.length > 0) {
                  return IconButton(
                    onPressed: () async {
                      var responseFromDialogBox = await Get.dialog(
                        AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text("Hapus Barang"),
                          content: const Text("Apakah anda yakin?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                "No",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back(result: "yesDelete");
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (responseFromDialogBox == "yesDelete") {
                        cartListController.selectedItemList
                            .forEach((selectedItemUserCartID) {
                          //delete selected items now
                          deleteSelectedItemsFromUserCartList(
                              selectedItemUserCartID);
                        });
                      }

                      calculateTotalAmount();
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 26,
                      color: Colors.red,
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
      body: Obx(
        () => cartListController.cartList.length > 0
            ? ListView.builder(
                itemCount: cartListController.cartList.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Cart cartModel = cartListController.cartList[index];

                  Goods goodsModel = Goods(
                    item_id: cartModel.item_id,
                    image: cartModel.image,
                    name: cartModel.name,
                    price: cartModel.price,
                    description: cartModel.description,
                    tags: cartModel.tags,
                  );

                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    child: Row(
                      children: [
                        //check box
                        GetBuilder(
                          init: CartListController(),
                          builder: (c) {
                            return IconButton(
                              onPressed: () {
                                if (cartListController.selectedItemList
                                    .contains(cartModel.cart_id)) {
                                  cartListController
                                      .deleteSelectedItem(cartModel.cart_id!);
                                } else {
                                  cartListController
                                      .addSelectedItem(cartModel.cart_id!);
                                }

                                calculateTotalAmount();
                              },
                              icon: Icon(
                                cartListController.selectedItemList
                                        .contains(cartModel.cart_id)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: cartListController.isSelectedAll
                                    ? Colors.black
                                    : Colors.black,
                              ),
                            );
                          },
                        ),

                        //name
                        //color size + price
                        //+ 2 -
                        //image
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                0,
                                index == 0 ? 8 : 4,
                                8,
                                index == cartListController.cartList.length - 1
                                    ? 8
                                    : 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(255, 211, 211, 211),
                                boxShadow: const [
                                  BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 2,
                                    color: Colors.white,
                                  ),
                                ],
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
                                        placeholder: const AssetImage(
                                            "images/place_holder.png"),
                                        image: NetworkImage(
                                          cartModel.image!,
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
                                  //name
                                  //color size + price
                                  //+ 2 -
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 7, top: 22),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //name
                                          Text(
                                            goodsModel.name.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontFamily: 'Afacad',
                                                fontWeight: FontWeight.bold),
                                          ),

                                          const SizedBox(height: 2),

                                          //color size + price
                                          // Row(
                                          //   children: [
                                          //     Padding(
                                          //       padding: const EdgeInsets.only(
                                          //           left: 0, right: 0),
                                          //       child: Text(
                                          //         "${cartModel.description!}",
                                          //         maxLines: 3,
                                          //         overflow:
                                          //             TextOverflow.ellipsis,
                                          //         style: const TextStyle(
                                          //           fontSize: 12,
                                          //           color: Colors.black,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              //price
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0, right: 0),
                                                child: Text(
                                                  "Rp. " +
                                                      formatCurrency(
                                                          goodsModel.price ??
                                                              0),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //-
                                      IconButton(
                                        onPressed: () {
                                          if (cartModel.quantity! - 1 >= 1) {
                                            updateQuantityInUserCart(
                                              cartModel.cart_id!,
                                              cartModel.quantity! - 1,
                                            );
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        cartModel.quantity.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          updateQuantityInUserCart(
                                            cartModel.cart_id!,
                                            cartModel.quantity! + 1,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  //item image
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const Center(
                child: Text("Keranjang Kosong"),
              ),
      ),
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (c) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 0),
                  color: Colors.white,
                  blurRadius: 3,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Harga di atas
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "Total Belanja:",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => Text(
                        "Rp. " + formatCurrency(cartListController.total),
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // Spacer yang dibatasi tingginya
                const SizedBox(height: 18),

                // Tombol di bawah
                Material(
                  color: cartListController.selectedItemList.length > 0
                      ? Colors.black
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      cartListController.selectedItemList.length > 0
                          ? Get.to(OrderNowScreen(
                              selectedCartListItemsInfo:
                                  getSelectedCartListItemsInformation(),
                              totalAmount: cartListController.total,
                              selectedCartIDs:
                                  cartListController.selectedItemList,
                            ))
                          : null;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15, // Tidak ada padding di sisi horizontal
                        vertical:
                            15, // Padding sebanyak 15 di sisi vertikal (7.5 atas dan 7.5 bawah)
                      ),
                      child: Text(
                        "Pesan Sekarang",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            constraints: const BoxConstraints(
                maxHeight: 130), // Ganti dengan tinggi maksimum yang diinginkan
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
