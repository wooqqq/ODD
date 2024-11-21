import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/constants/appcolors.dart';
import '../home/controller/main_controller.dart';

class Navbar extends StatelessWidget {
  final MainController controller = Get.find<MainController>();

  Navbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
      height: 65,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        showUnselectedLabels: true,
        currentIndex: controller.selectedIndex.value,
        onTap: (index) => controller.changeIndex(index, context),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/navbar/home_default.png',
                width: 24, height: 24),
            activeIcon: Image.asset('assets/icons/navbar/home_select.png',
                width: 24, height: 24),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/navbar/search_default.png',
                width: 24, height: 24),
            activeIcon: Image.asset(
                'assets/icons/navbar/search_select.png',
                width: 24,
                height: 24),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/navbar/pay_default.png',
                width: 24, height: 24),
            activeIcon: Image.asset('assets/icons/navbar/pay_select.png',
                width: 24, height: 24),
            label: '결제',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/navbar/order_default.png',
                width: 24, height: 24),
            activeIcon: Image.asset(
                'assets/icons/navbar/order_select.png',
                width: 24,
                height: 24),
            label: '주문내역',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons/navbar/my_default.png',
                width: 24, height: 24),
            activeIcon: Image.asset('assets/icons/navbar/my_select.png',
                width: 24, height: 24),
            label: 'MY',
          ),
        ],
        selectedItemColor: AppColors.black,
        unselectedItemColor: AppColors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
      ),
    ));
  }
}
