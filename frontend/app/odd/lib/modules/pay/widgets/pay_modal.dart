import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/modules/point/controller/point_controller.dart';
import '../../../constants/appcolors.dart';

class PayModal extends StatelessWidget {
  const PayModal({super.key});

  @override
  Widget build(BuildContext context) {
    final PointController pointController = Get.put(PointController());
    return Container(
      padding: const EdgeInsets.all(25),
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(
        minHeight: 300, // 최소 높이를 설정 (예: 250)
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: AppColors.lightgrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            "결제/적립",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '현재 포인트',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 20),
              Obx(() => Text(
                    '${pointController.formattedPoint} P',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
