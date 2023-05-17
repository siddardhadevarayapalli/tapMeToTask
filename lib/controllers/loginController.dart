import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController partnerNameController = TextEditingController();
  var enableEdit = false;
  double width = 100;
  double height = 100;
  BorderRadiusGeometry borderRadius = BorderRadius.circular(8);
  Color color = Colors.green;
  bool isMale = false;
  String loginAsset = "assets/femalebear.json";
  String femaleHead = "assets/femalehead.json";
  String maleHead = "assets/malehead.json";
  String back = "assets/back.jpg";
  bool showSpinner = false;
}
