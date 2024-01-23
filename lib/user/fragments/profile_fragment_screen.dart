// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, avoid_function_literals_in_foreach_calls, avoid_print, prefer_is_empty, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:magazza/api_connection/api_connection.dart';
import 'package:magazza/user/addres/user_address_screen.dart';
import 'package:magazza/user/authentication/login_screen.dart';
import 'package:magazza/user/model/order.dart';
import 'package:magazza/user/userPreferences/current_users.dart';
import 'package:magazza/user/userPreferences/user_preferences.dart';
import 'package:magazza/user/model/address.dart';

class ProfileFragmentScreen extends StatelessWidget {
  ProfileFragmentScreen({super.key});

  final _currentUser = Get.put(CurrentUser());

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

  signOutUser() async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Keluar",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text("Apakah anda yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Tidak",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: "KeluarUser");
            },
            child: const Text(
              "Iya",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
    if (resultResponse == "KeluarUser") {
      RememberUsersPrefs.readUserInfo().then((value) {
        Get.off(LoginScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 15,
        ),
        Center(
          child: CircleAvatar(
            backgroundImage: AssetImage("images/user.png"),
            radius: 100,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 1,
                color: Colors.white10,
              ),
            ],
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
                            'Data Diri',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Nama',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _currentUser.user.user_name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Email',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _currentUser.user.user_email,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Nomor Hp',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _currentUser.user.user_number,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
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
        FutureBuilder(
            future: getCurrentUserAddress(),
            builder: (context, AsyncSnapshot<List<Address>> dataSnapShot) {
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
                print(dataSnapShot.data!.length);
                return ListView.builder(
                    itemCount: dataSnapShot.data!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      Address eachAddressItemRecord = dataSnapShot.data![index];

                      return Container(
                        // onTap: () {
                        //   // Get.to(ItemsDetailsScreen(
                        //   //     itemInfo: clickedGoodItem));
                        // },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                            20,
                            index == 0 ? 8 : 4,
                            20,
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
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Alamat',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Alamat',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Material(
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(UserAddressScreen());
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.black,
                                                size: 24,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "Tambahkan Alamat",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              // Padding between icon and text
                                            ],
                                          ),
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
              }
            }),
        const SizedBox(height: 15),
        Center(
          child: Material(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () {
                signOutUser();
              },
              borderRadius: BorderRadius.circular(32),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 158,
                  vertical: 12,
                ),
                child: const Text(
                  "Keluar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
