import 'dart:io';
import 'dart:typed_data';

import 'package:ai_image_enlarger/app/routes/app_pages.dart';
import 'package:ai_image_enlarger/constants/sizeConstant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../controllers/image_screen_controller.dart';

class ImageScreenView extends GetWidget<ImageScreenController> {
  const ImageScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAndToNamed(Routes.HOME);
        return await true;
      },
      child: Obx(() {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              actions: [
                GestureDetector(
                  onTap: () {
                    controller.screenshotController
                        .capture(
                            delay: Duration(
                      milliseconds: 10,
                    ))
                        .then((value) {
                      ShowCapturedWidget(context, value!);
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: MySize.getHeight(8.0)),
                    alignment: Alignment.center,
                    child: Text(
                      "Save",
                      style: TextStyle(fontSize: MySize.getHeight(18)),
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                (controller.hasDate.isTrue)
                    ? Screenshot(
                        controller: controller.screenshotController,
                        child: Stack(
                          children: [
                            (controller.is2d.isTrue)
                                ? getImageByLink(
                                    url: "${controller.image2D}",
                                    height: MySize.getHeight(400),
                                    boxFit: BoxFit.contain,
                                    width: MySize.getHeight(500))
                                : getImageByLink(
                                    url: "${controller.image3D}",
                                    height: MySize.getHeight(350),
                                    width: MySize.getHeight(500)),
                            (controller.isSwitched.value)
                                ? Positioned(
                                    left: MySize.getWidth(10),
                                    bottom: MySize.getHeight(5),
                                    child: Container(
                                      height: MySize.getHeight(100),
                                      width: MySize.getHeight(100),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                              MySize.getHeight(75))),
                                      child: ClipOval(
                                        child: Image.file(
                                            File(controller.imagePath),
                                            fit: BoxFit.fitWidth),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : Image.file(
                        File(controller.imagePath),
                        height: MySize.getHeight(300),
                        width: MySize.getHeight(500),
                      ),
                Row(
                  children: [
                    Switch(
                      onChanged: (value) {
                        controller.isSwitched.toggle();
                      },
                      value: controller.isSwitched.value,
                    ),
                  ],
                ),
                Spacer(),
                (controller.hasDate.isTrue)
                    ? (controller.isFromCatoonizer.isTrue)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.is2d.value = true;
                                },
                                child: getImageByLink(
                                    url:
                                        "http://get.imglarger.com:8889/results/${controller.imageID}_a.jpg",
                                    height: MySize.getHeight(100),
                                    width: MySize.getHeight(100)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.is2d.value = false;
                                },
                                child: getImageByLink(
                                    url:
                                        "http://get.imglarger.com:8889/results/${controller.imageID}_t.jpg",
                                    height: MySize.getHeight(100),
                                    width: MySize.getHeight(100)),
                              ),
                            ],
                          )
                        : Container()
                    : Container(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<dynamic> ShowCapturedWidget(
    BuildContext context,
    Uint8List capturedImage,
  ) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Screenshot of your Drawing"),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MySize.getHeight(10)),
              child: GestureDetector(
                onTap: () async {
                  final image = await controller.screenshotController
                      .captureFromWidget(Container(
                    color: Colors.white,
                    child: Stack(
                      children: [
                        (controller.is2d.isTrue)
                            ? getImageByLink(
                                url: "${controller.image2D}",
                                height: MySize.getHeight(350),
                                boxFit: BoxFit.contain,
                                width: MySize.getHeight(500))
                            : getImageByLink(
                                url: "${controller.image3D}",
                                height: MySize.getHeight(350),
                                width: MySize.getHeight(500)),
                        (controller.isSwitched.value)
                            ? Positioned(
                                left: MySize.getWidth(10),
                                bottom: MySize.getHeight(5),
                                child: Container(
                                  height: MySize.getHeight(100),
                                  width: MySize.getHeight(100),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(
                                          MySize.getHeight(75))),
                                  child: ClipOval(
                                    child: Image.file(
                                        File(controller.imagePath),
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ));

                  if (capturedImage.isNotEmpty) {
                    await [Permission.storage].request();
                    final time = DateTime.now();
                    final name = "Screenshot${time}";
                    final result =
                        await ImageGallerySaver.saveImage(image, name: name);
                    Fluttertoast.showToast(
                        msg: "Success!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    print("Path===============${result['filePath']}");
                  }
                },
                child: Icon(Icons.download),
              ),
            ),
          ],
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }
}
