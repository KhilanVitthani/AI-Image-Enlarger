import 'dart:io';

import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../utilities/buttons.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';

class ShareFileController extends GetxController {
  File? capturedImage;
  RxBool isFromMyCollection = false.obs;
  RxBool isFromHome = false.obs;
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  @override
  void onInit() {
    if (Get.arguments != null) {
      capturedImage = Get.arguments[ArgumentConstant.capuredImage];
      isFromMyCollection.value =
          Get.arguments[ArgumentConstant.isFromMyCollection];
      isFromHome.value = Get.arguments[ArgumentConstant.isFromHome];
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
