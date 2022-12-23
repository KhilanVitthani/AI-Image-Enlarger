import 'package:get/get.dart';

import '../modules/Image_screen/bindings/image_screen_binding.dart';
import '../modules/Image_screen/views/image_screen_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/my_collection_page/bindings/my_collection_page_binding.dart';
import '../modules/my_collection_page/views/my_collection_page_view.dart';
import '../modules/setting_page/bindings/setting_page_binding.dart';
import '../modules/setting_page/views/setting_page_view.dart';
import '../modules/share_file/bindings/share_file_binding.dart';
import '../modules/share_file/views/share_file_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE_SCREEN,
      page: () => ImageScreenView(),
      binding: ImageScreenBinding(),
    ),
    GetPage(
      name: _Paths.SHARE_FILE,
      page: () => const ShareFileView(),
      binding: ShareFileBinding(),
    ),
    GetPage(
      name: _Paths.SETTING_PAGE,
      page: () => const SettingPageView(),
      binding: SettingPageBinding(),
    ),
    GetPage(
      name: _Paths.MY_COLLECTION_PAGE,
      page: () => const MyCollectionPageView(),
      binding: MyCollectionPageBinding(),
    ),
  ];
}
