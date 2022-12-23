import 'dart:io';
import 'dart:typed_data';

import 'package:ai_image_enlarger/app/routes/app_pages.dart';
import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:ai_image_enlarger/constants/color_constant.dart';
import 'package:ai_image_enlarger/constants/sizeConstant.dart';
import 'package:ai_image_enlarger/models/categoriesModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../utilities/buttons.dart';
import '../controllers/image_screen_controller.dart';

class ImageScreenView extends GetWidget<ImageScreenController> {
  const ImageScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageScreenController>(
        init: ImageScreenController(),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              showConfirmationDialog(
                  context: context,
                  text: "Are you sure you want to lost your progress!.",
                  submitText: "Yes",
                  cancelText: "Cancel",
                  submitCallBack: () {
                    Get.offAllNamed(Routes.HOME);
                  },
                  cancelCallback: () {
                    Get.back();
                  });
              return await true;
            },
            child: Obx(() {
              return SafeArea(
                child: Scaffold(
                  backgroundColor: appTheme.primaryTheme,
                  appBar: (controller.hasDate.isTrue)
                      ? AppBar(
                          backgroundColor: appTheme.primaryTheme,
                          elevation: 0,
                          actions: [
                            GestureDetector(
                              onTap: () {
                                controller.screenshotController
                                    .capture(
                                        delay: Duration(
                                  milliseconds: 10,
                                ))
                                    .then((value) async {
                                  if (value!.isNotEmpty) {
                                    Uint8List imageInUnit8List = value;
                                    final tempDir =
                                        await getTemporaryDirectory();
                                    await [Permission.storage].request();
                                    final time = DateTime.now();
                                    final name = "Screenshot${time}";
                                    File file = await File(
                                            '${tempDir.path}/Screenshot${time}.png')
                                        .create();
                                    await ImageGallerySaver.saveImage(value,
                                        name: name);
                                    Fluttertoast.showToast(
                                        msg: "Success!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    // GallerySaver.saveImage(file.path)
                                    //     .then((value) {
                                    //   Fluttertoast.showToast(
                                    //       msg: "Success!",
                                    //       toastLength: Toast.LENGTH_SHORT,
                                    //       gravity: ToastGravity.BOTTOM,
                                    //       timeInSecForIosWeb: 1,
                                    //       textColor: Colors.white,
                                    //       fontSize: 16.0);
                                    // });
                                    controller.addImageToDataBase(
                                        imageFile: file.path);
                                    Get.offAndToNamed(Routes.SHARE_FILE,
                                        arguments: {
                                          ArgumentConstant.capuredImage: file,
                                          ArgumentConstant.isFromMyCollection:
                                              false,
                                        });
                                    file.writeAsBytesSync(imageInUnit8List);
                                  }
                                });
                              },
                              child: Container(
                                width: MySize.getWidth(70),
                                height: MySize.getHeight(50),
                                padding: EdgeInsets.symmetric(
                                    horizontal: MySize.getHeight(8.0)),
                                alignment: Alignment.center,
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.karla(
                                      fontSize: MySize.getHeight(18)),
                                ),
                              ),
                            )
                          ],
                        )
                      : null,
                  body: Column(
                    children: [
                      Spacer(),
                      (controller.hasDate.isTrue)
                          ? Screenshot(
                              controller: controller.screenshotController,
                              child: Stack(
                                children: [
                                  (controller.is2d.isTrue)
                                      ? getImageByLink(
                                          url: "${controller.image2D}",
                                          height: MySize.getHeight(400),
                                          boxFit: BoxFit.cover,
                                          width: MySize.screenWidth,
                                        )
                                      : getImageByLink(
                                          url: "${controller.image3D}",
                                          boxFit: BoxFit.cover,
                                          height: MySize.getHeight(400),
                                          width: MySize.screenWidth),
                                  (controller.isSwitched.value)
                                      ? Positioned(
                                          left: MySize.getWidth(22),
                                          bottom: MySize.getHeight(20),
                                          child: Container(
                                            height: MySize.getHeight(116),
                                            width: MySize.getHeight(116),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: MySize.getWidth(2.5),
                                                  color: Colors.white),
                                              color: Colors.black,
                                              shape: BoxShape.circle,
                                            ),
                                            child: ClipOval(
                                              child: Image.file(
                                                  File(controller
                                                      .selectedImagePath.value),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          : Stack(
                              children: [
                                Container(
                                  height: MySize.screenHeight -
                                      MediaQuery.of(context).padding.top,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent.withOpacity(0.9),
                                    image: DecorationImage(
                                      image: FileImage(File(
                                          controller.selectedImagePath.value)),
                                      fit: BoxFit.contain,
                                      opacity: 0.2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "We are drawing your Cartoon!",
                                          style: GoogleFonts.karla(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: MySize.getHeight(18)),
                                        ),
                                        Container(
                                          child: Image.asset(
                                            imagePath + "loading.gif",
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: MySize.getWidth(24.17),
                                  top: MySize.getHeight(31.17),
                                  child: GestureDetector(
                                    onTap: () {
                                      showConfirmationDialog(
                                          context: context,
                                          text:
                                              "Are you sure you want to lost your progress!.",
                                          submitText: "Yes",
                                          cancelText: "Cancel",
                                          submitCallBack: () {
                                            Get.offAllNamed(Routes.HOME);
                                          },
                                          cancelCallback: () {
                                            Get.back();
                                          });
                                    },
                                    child: Container(
                                      child: SvgPicture.asset(
                                          imagePath + "close.svg",
                                          height: MySize.getHeight(20),
                                          width: MySize.getWidth(20)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      (controller.hasDate.isTrue)
                          ? Row(
                              children: [
                                Text(
                                  "Mini-Image",
                                  style: GoogleFonts.karla(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MySize.getHeight(14)),
                                ),
                                Switch(
                                  onChanged: (value) {
                                    controller.isSwitched.toggle();
                                  },
                                  value: controller.isSwitched.value,
                                  activeColor: appTheme.buttonColor,
                                ),
                              ],
                            )
                          : Container(),
                      Spacer(),
                      (controller.hasDate.isTrue)
                          ? (controller.isFromCatoonizer.isTrue)
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MySize.getHeight(30)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      cartoonImage(
                                        onTap: () {
                                          controller.is2d.value = true;
                                        },
                                        url:
                                            "http://get.imglarger.com:8889/results/${controller.imageID}_a.jpg",
                                        color: (controller.is2d.isTrue)
                                            ? appTheme.buttonColor
                                            : appTheme.textGrayColor,
                                        name: "Art-01",
                                        context: context,
                                      ),
                                      cartoonImage(
                                        onTap: () {
                                          controller.is2d.value = false;
                                        },
                                        url:
                                            "http://get.imglarger.com:8889/results/${controller.imageID}_t.jpg",
                                        color: (controller.is2d.isFalse)
                                            ? appTheme.buttonColor
                                            : appTheme.textGrayColor,
                                        name: "Art-02",
                                        isFrom3d: true,
                                        context: context,
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     controller.is2d.value = false;
                                      //   },
                                      //   child: getImageByLink(
                                      //       url:
                                      //           "http://get.imglarger.com:8889/results/${controller.imageID}_t.jpg",
                                      //       height: MySize.getHeight(100),
                                      //       width: MySize.getHeight(100)),
                                      // ),
                                    ],
                                  ),
                                )
                              : Container()
                          : Container(),
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }

  GestureDetector cartoonImage(
      {required BuildContext context,
      required VoidCallback onTap,
      required String url,
      Color? color,
      bool isFrom3d = false,
      String? name}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MySize.getWidth(72),
        height: MySize.getHeight(125),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(MySize.getHeight(8))),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MySize.getHeight(2),
                left: MySize.getHeight(2),
                right: MySize.getHeight(2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(
                    MySize.getHeight(8),
                  ),
                  topLeft: Radius.circular(
                    MySize.getHeight(8),
                  ),
                ),
                child: getImageByLink(
                  url: url,
                  height: MySize.getHeight(100),
                  boxFit: BoxFit.fitHeight,
                  width: MySize.getHeight(68),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MySize.getWidth(17),
                  vertical: MySize.getHeight(3)),
              child: Text(
                " ${name}",
                style: GoogleFonts.karla(
                  color: Colors.white,
                  fontSize: MySize.getHeight(12),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
