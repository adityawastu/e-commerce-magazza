//ignore_for_file: prefer_const_constructors
//import 'package:flutter/foundation.dart';
// import 'package:magazza/user/authentication/signup_screen.dart';
// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:magazza/api_connection/api_connection.dart';
import 'package:magazza/user/authentication/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:magazza/user/model/user.dart';
import 'package:email_validator/email_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var FormKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var numberController = TextEditingController();
  var passwordController = TextEditingController();
  var repasswordController = TextEditingController();
  var isObsecure = true.obs;
  //var repasswordController = TextEditingController();

  void emailValidatorText() {
    final bool isValid = EmailValidator.validate(emailController.text.trim());
    if (isValid) {
      validateUserEmail();
      Future.delayed(Duration(seconds: 2), () {
        Get.to(LoginScreen());
      });
    } else {
      Fluttertoast.showToast(msg: "Masukkan email yang sesuai");
    }
  }

  validateUserEmail() async {
    try {
      var res = await http.post(
        Uri.parse(API.ValidateEmail),
        body: {
          'user_email': emailController.text.trim(),
        },
      );

      if (res.statusCode == 200) {
        //connect api
        var resBodyOfValidateEmail = jsonDecode(res.body);
        if (resBodyOfValidateEmail['emailFound'] == true) {
          Fluttertoast.showToast(msg: "Email sudah terdaftar");
        } else {
          RegisterandSaveUserRecord();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  RegisterandSaveUserRecord() async {
    User userModel = User(
      1,
      nameController.text.trim(),
      numberController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    try {
      var res = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJson(),
      );

      if (res.statusCode == 200) {
        var resBodyOfSignUp = jsonDecode(res.body);
        if (resBodyOfSignUp['succes'] == true) {
          Fluttertoast.showToast(msg: "Pendaftaran berhasil");
          Future.delayed(Duration(seconds: 2), () {
            setState(() {
              nameController.clear();
              numberController.clear();
              emailController.clear();
              passwordController.clear();
              repasswordController.clear();
            });
          });
        }
      } else {
        Fluttertoast.showToast(msg: "error");
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  bool isPasswordMatch() {
    return passwordController.text == repasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                    ),
                    //login form
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Registrasi',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Silahkan mengisi form registrasi dibawah ini',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Form(
                            key: FormKey,
                            child: Column(
                              children: [
                                //username
                                TextFormField(
                                  controller: nameController,
                                  validator: (val) =>
                                      val == "" ? "Masukkan username" : null,
                                  decoration: InputDecoration(
                                      hintText: "Username",
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

                                //email
                                TextFormField(
                                  controller: emailController,
                                  validator: (val) =>
                                      val == "" ? "Masukkan Email" : null,
                                  decoration: InputDecoration(
                                      hintText: "Email",
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

                                //number
                                TextFormField(
                                  controller: numberController,
                                  validator: (val) =>
                                      val == "" ? "Masukkan Nomor Hp" : null,
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

                                //pw
                                Obx(
                                  () => TextFormField(
                                    controller: passwordController,
                                    obscureText: isObsecure.value,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return "Masukkan Password";
                                      } else if (val.length < 8) {
                                        return "Password minimal harus 8 karakter";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon: Obx(
                                          () => GestureDetector(
                                            onTap: () {
                                              isObsecure.value =
                                                  !isObsecure.value;
                                            },
                                            child: Icon(
                                              isObsecure.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        hintText: "Password",
                                        hintStyle: TextStyle(fontSize: 14),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        )),
                                  ),
                                ),

                                SizedBox(
                                  height: 18,
                                ),

                                Obx(
                                  () => TextFormField(
                                    controller: repasswordController,
                                    obscureText: isObsecure.value,
                                    validator: (val) {
                                      if (val == "") {
                                        return "Masukkan Password";
                                      } else if (val !=
                                          passwordController.text) {
                                        return "Password tidak cocok";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon: Obx(
                                          () => GestureDetector(
                                            onTap: () {
                                              isObsecure.value =
                                                  !isObsecure.value;
                                            },
                                            child: Icon(
                                              isObsecure.value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        hintText: "Konfirmasi Password",
                                        hintStyle: TextStyle(fontSize: 14),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        )),
                                  ),
                                ),

                                SizedBox(
                                  height: 18,
                                ),
                                // login button

                                Material(
                                  color:
                                      const Color.fromARGB(179, 114, 100, 100),
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: () {
                                      if (FormKey.currentState!.validate()) {
                                        if (isPasswordMatch()) {
                                          // Password cocok, lakukan pendaftaran
                                          emailValidatorText();
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Password tidak cocok");
                                        }
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 150,
                                      ),
                                      child: Text(
                                        "Daftar",
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
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Sudah punya akun?"),
                              TextButton(
                                onPressed: () {
                                  Get.to(LoginScreen());
                                },
                                child: Text(
                                  "Masuk",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
