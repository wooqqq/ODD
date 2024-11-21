import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/constants/appcolors.dart';
import 'package:odd/modules/common/default_layout.dart';

class PointScreen extends StatelessWidget {
  const PointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // 상단 영역
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/icons/back_icon.png',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    const Text(
                      '포인트 내역',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 48), // 오른쪽 여백을 맞추기 위한 빈 공간
                  ],
                ),
                const SizedBox(height: 30),
                // 포인트 정보
                const Column(
                  children: [
                    Text(
                      '현재 포인트',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '3,292 P',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 구분선 - 아래는 날짜별 포인트 내역정보임. 추후 수정
          const Divider(
            thickness: 4,
            color: AppColors.background,
          ),
        ],
      ),
    );
  }
}
