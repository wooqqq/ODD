import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/modules/common/cart_button.dart';
import 'package:odd/modules/notification/screens/notification_screen.dart';
import '../../../constants/appcolors.dart';
import '../../cart/controller/cart_controller.dart';
import '../../common/tab_button.dart';
import '../controller/home_controller.dart';
import 'package:odd/modules/home/widgets/home_content.dart';
import 'package:odd/modules/common/home_layout.dart';
import 'package:odd/modules/home/widgets/gs25_content.dart';

import '../widgets/gsfresh_content.dart';
import '../widgets/wine25_content.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 로고
                Obx(() => Text(
                      controller.selectedPlatform.value,
                      style: TextStyle(
                        fontFamily: 'LogoFont',
                        fontWeight: FontWeight.w700,
                        color: controller.primaryColor.value,
                        fontSize: 24,
                      ),
                    )),
                Row(
                  children: [
                    // 알림
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/notification_icon.png',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        Get.to(const NotificationScreen());
                      },
                    ),
                    // 장바구니 아이콘
                    CartButton()
                  ],
                )
              ],
            ),
            const SizedBox(height: 13),
            // 탭
            _TabBar(controller: controller),
            const SizedBox(height: 13),
            // 콘텐츠 부분
            Obx(() {
              switch (controller.selectedPlatform.value) {
                case 'GS25':
                  return GS25Content(platform: controller.selectedPlatform.value);
                case 'GS더프레시':
                  return GSfreshContent(platform: controller.selectedPlatform.value);
                case 'wine25':
                  return Wine25Content(platform: controller.selectedPlatform.value);
                default:
                  return const HomeContent();
              }
            }),
          ],
        ),
      ),
    );
  }
}

// 탭바
class _TabBar extends StatelessWidget {
  final HomeController controller;
  const _TabBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(() => TabButton(
              title: '홈',
              isSelected: controller.selectedPlatform.value == '우리동네단골',
              onTap: () => controller.changePlatform('우리동네단골'),
              selectedColor: controller.primaryColor.value
            )),
        Obx(() => TabButton(
              title: 'GS25',
              isSelected: controller.selectedPlatform.value == 'GS25',
              onTap: () => controller.changePlatform('GS25'),
              selectedColor: controller.primaryColor.value
            )),
        Obx(() => TabButton(
              title: 'GS더프레시',
              isSelected: controller.selectedPlatform.value == 'GS더프레시',
              onTap: () => controller.changePlatform('GS더프레시'),
              selectedColor: controller.primaryColor.value
            )),
        Obx(() => TabButton(
              title: '와인25',
              isSelected: controller.selectedPlatform.value == 'wine25',
              onTap: () => controller.changePlatform('wine25'),
              selectedColor: controller.primaryColor.value
            )),
      ],
    );
  }
}
