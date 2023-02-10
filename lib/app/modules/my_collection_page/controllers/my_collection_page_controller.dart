import 'dart:convert';

import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:ai_image_enlarger/constants/sizeConstant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';

class MyCollectionPageController extends GetxController {
  RxList myImage = RxList([]);
  var connectivityResult;

  @override
  Future<void> onInit() async {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.myCollection))) {
      RxList myImage1 = RxList([]);
      connectivityResult = await Connectivity().checkConnectivity();
      myImage1.value = jsonDecode(box.read(ArgumentConstant.myCollection));
      print(myImage);
      myImage.value = myImage1.reversed.toList();
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
