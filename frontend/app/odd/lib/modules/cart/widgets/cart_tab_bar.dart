import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/appcolors.dart';
import '../../common/tab_button.dart';
import '../controller/cart_controller.dart';

class CartTabBar extends StatelessWidget {
  final String selectedPlatform;
  final String selectedServiceType;
  final Function(String platform, String serviceType) onTabSelected;

  CartTabBar({
    super.key,
    required this.selectedPlatform,
    required this.selectedServiceType,
    required this.onTabSelected,
  });

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Obx(() => Row(
        children: [
          TabButton(
            title:
            'GS25 픽업 (${cartController.groupedCartItems['GS25']?['픽업']?.length ?? 0})',
            isSelected:
            selectedPlatform == 'GS25' && selectedServiceType == '픽업',
            onTap: () => onTabSelected('GS25', '픽업'),
            selectedBorderColor: AppColors.grey,
            selectedTextColor: AppColors.black,
            selectedColor: AppColors.white,
            imagePath: 'assets/images/cart/gs_pickup_cart.png',
          ),
          const SizedBox(width: 8),
          TabButton(
            title:
            'GS25 배달 (${cartController.groupedCartItems['GS25']?['배달']?.length ?? 0})',
            isSelected:
            selectedPlatform == 'GS25' && selectedServiceType == '배달',
            onTap: () => onTabSelected('GS25', '배달'),
            selectedBorderColor: AppColors.grey,
            selectedTextColor: AppColors.black,
            selectedColor: AppColors.white,
            imagePath: 'assets/images/cart/gs_delivery_cart.png',
          ),
          const SizedBox(width: 8),
          TabButton(
            title:
            'GS더프레시 픽업 (${cartController.groupedCartItems['GS더프레시']?['픽업']?.length ?? 0})',
            isSelected: selectedPlatform == 'GS더프레시' &&
                selectedServiceType == '픽업',
            onTap: () => onTabSelected('GS더프레시', '픽업'),
            selectedBorderColor: AppColors.grey,
            selectedTextColor: AppColors.black,
            selectedColor: AppColors.white,
            imagePath: 'assets/images/cart/fresh_pickup_cart.png',
          ),
          const SizedBox(width: 8),
          TabButton(
            title:
            'GS더프레시 배달 (${cartController.groupedCartItems['GS더프레시']?['배달']?.length ?? 0})',
            isSelected: selectedPlatform == 'GS더프레시' &&
                selectedServiceType == '배달',
            onTap: () => onTabSelected('GS더프레시', '배달'),
            selectedBorderColor: AppColors.grey,
            selectedTextColor: AppColors.black,
            selectedColor: AppColors.white,
            imagePath: 'assets/images/cart/fresh_delivery_cart.png',
          ),
          const SizedBox(width: 8),
          TabButton(
            title:
            '와인25 (${cartController.groupedCartItems['wine25']?['픽업']?.length ?? 0})',
            isSelected: selectedPlatform == 'wine25' &&
                selectedServiceType == '픽업',
            onTap: () => onTabSelected('wine25', '픽업'),
            selectedBorderColor: AppColors.grey,
            selectedTextColor: AppColors.black,
            selectedColor: AppColors.white,
            imagePath: 'assets/images/cart/wine_cart.png',
          ),
        ],
      )),
    );
  }
}
