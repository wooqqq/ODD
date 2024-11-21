import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:odd/constants/appcolors.dart';
import 'package:odd/modules/cart/screens/cart_screen.dart';
import 'package:odd/modules/common/default_layout.dart';
import 'package:odd/modules/point/controller/point_controller.dart';
import 'package:odd/modules/point/screens/point_screen.dart';
import 'package:odd/modules/user/controller/login_controller.dart';
import '../../home/controller/main_controller.dart';

class MyScreen extends StatelessWidget {
  final storage = GetStorage();
  MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller =
        Get.find<MainController>(); // MainController 가져오기
    final PointController pointController = Get.put(PointController());

    return DefaultLayout(
      header: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                'MY',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),

          // Welcome 메시지 및 포인트 정보
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                const Text(
                  'WELCOME ',
                  style: TextStyle(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                Text(
                  '${storage.read('nickname') ?? '사용자'}님',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 포인트 컨테이너
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.lightgrey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('POINT',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Obx(() => Text(
                        '${pointController.formattedPoint} P', // 컨트롤러의 point 값 표시
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // 아이콘 섹션
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(Icons.favorite_border_rounded),
                    SizedBox(height: 4),
                    Text(
                      '찜',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(height: 4),
                    Text(
                      '나의후기',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.monetization_on_outlined),
                    SizedBox(height: 4),
                    Text(
                      '포인트',
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 주문 정보 섹션
          const Divider(
            thickness: 4,
            color: AppColors.background,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            child: Text(
              '주문정보',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Get.to(() => const CartScreen());
                  },
                  child: const Text('장바구니', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    controller.changeIndex(3, context);
                  },
                  child: const Text('주문 내역', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 8),
                const Text('나만의 냉장고', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 계정 관리 섹션 수정
          const Divider(thickness: 4, color: AppColors.background),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            child: Text(
              '계정관리',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Get.find<LoginController>().logout(); // 로그아웃 함수 호출
                  },
                  child: const Text('로그아웃', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 8),
                const Text('회원탈퇴', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
