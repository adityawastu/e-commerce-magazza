//ignore_for_file: prefer_const_constructors
// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, unused_field, prefer_final_fields, unused_element, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:magazza/api_connection/api_connection.dart';
import 'package:magazza/user/authentication/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:magazza/user/fragments/dashboard_of_fragments.dart';
import 'package:magazza/user/userPreferences/current_users.dart';
import 'package:geocoding/geocoding.dart';
//import 'package:geolocation/geolocationmaps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class UserAddressScreen extends StatefulWidget {
  const UserAddressScreen({super.key});

  @override
  State<UserAddressScreen> createState() => _UserAddressScreenState();
}

class _UserAddressScreenState extends State<UserAddressScreen> {
  var FormKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var numberController = TextEditingController();
  var addressController = TextEditingController();
  //var pointlatitudeController = TextEditingController();

  final currentOnlineUser = Get.put(CurrentUser());

  Position? _currentLocation;
  late bool servicePermission = false;
  late LocationPermission permission;
  String _currentAdress = "";

  Future<Position> _getCurrentLocation() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      print("service disable");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  _getAddres() async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);

      Placemark place = placemark[0];

      setState(() {
        _currentAdress =
            "${place.thoroughfare},${place.locality}, ${place.subLocality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  RegisterandSaveUserAddressRecord() async {
    try {
      var response = await http.post(
        Uri.parse(API.addAddress),
        body: {
          'address_id': '',
          'user_id': currentOnlineUser.user.user_id.toString(),
          'receiver_name': nameController.text.trim().toString(),
          'receiver_number': numberController.text.trim().toString(),
          'receiver_address': addressController.text.trim().toString(),
          'receiver_point_latitude': _currentLocation!.latitude.toString(),
          'receiver_point_longitude': _currentLocation!.longitude.toString(),
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        var resBodyOfUploadAddress = jsonDecode(response.body);
        if (resBodyOfUploadAddress['success'] == true) {
          Fluttertoast.showToast(msg: "Berhasil di Upload");

          setState(() {
            nameController.clear();
            numberController.clear();
            addressController.clear();
            // pointController.clear();
          });
          Future.delayed(Duration(seconds: 1), () {
            Get.to(DashboardOfFragments());
          });
        } else {
          Fluttertoast.showToast(msg: "Gagal di Upload");
        }
      } else {
        Fluttertoast.showToast(msg: "200");
      }
    } catch (errorMsg) {
      print(
        "Errorcoy : " + errorMsg.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
        title: const Text(
          "Alamat saya",
          style: TextStyle(
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      backgroundColor: Color.fromRGBO(245, 245, 245, 1.0),
      body: LayoutBuilder(
        builder: (context, cons) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    //login screen header

                    //login form
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(245, 245, 245, 1.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Text(
                          //   'Registrasi',
                          //   style: TextStyle(
                          //     fontSize: 30,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          Text(
                            'Silahkan isi alamat anda',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Form(
                            key: FormKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: nameController,
                                  validator: (val) => val == ""
                                      ? "Masukkan Nama Penerima"
                                      : null,
                                  decoration: InputDecoration(
                                      hintText: "Nama penerima",
                                      hintStyle: TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      )),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                TextFormField(
                                  controller: numberController,
                                  validator: (val) => val == ""
                                      ? "Masukkan Nomor Ponsel"
                                      : null,
                                  decoration: InputDecoration(
                                      hintText: "Nomor Ponsel",
                                      hintStyle: TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      )),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                TextFormField(
                                  controller: addressController,
                                  validator: (val) => val == ""
                                      ? "Masukkan Alamat Lengkap"
                                      : null,
                                  decoration: InputDecoration(
                                      hintText: "Alamat Lengkap",
                                      hintStyle: TextStyle(fontSize: 14),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 6,
                                      )),
                                ),

                                SizedBox(
                                  height: 18,
                                ),
                                Material(
                                  color:
                                      const Color.fromARGB(179, 114, 100, 100),
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: () async {
                                      _currentLocation =
                                          await _getCurrentLocation();
                                      await _getAddres();

                                      print("${_currentAdress}");
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 50,
                                      ),
                                      child: Text(
                                        "Dapatkan pin point",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Material(
                                  color:
                                      const Color.fromARGB(179, 114, 100, 100),
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: () {
                                      if (FormKey.currentState!.validate()) {
                                        RegisterandSaveUserAddressRecord();
                                      } else {
                                        print("gagal");
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 100,
                                      ),
                                      child: Text(
                                        "Tambahkan Alamat",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //pw
                              ],
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     const Text("Sudah punya akun?"),
                          //     TextButton(
                          //       onPressed: () {
                          //         Get.to(LoginScreen());
                          //       },
                          //       child: Text(
                          //         "Masuk",
                          //         style: TextStyle(
                          //           color: Colors.black,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
