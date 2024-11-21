import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../constants/appcolors.dart';
import '../cart/controller/cart_controller.dart';
import '../cart/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Image.asset(
            'assets/icons/bag_icon.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            Get.to(const CartScreen());
          },
        ),
        // 카운트 뱃지
        Positioned(
          right: 4,
          bottom: 4,
          child: Obx(() {
            int itemCount = cartController.totalItems;
            return itemCount > 0
                ? Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.notice,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ),
      ],
    );
  }
}
