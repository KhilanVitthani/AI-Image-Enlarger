import 'package:ai_image_enlarger/app/routes/app_pages.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../../../../main.dart';
import '../../../../utilities/timer_service.dart';

class SettingPageController extends GetxController {
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'com.mobileappxperts.aieffects.toonphotoeditor',
    // appStoreIdentifier: '1491556149',
  );
  @override
  void onInit() {
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
