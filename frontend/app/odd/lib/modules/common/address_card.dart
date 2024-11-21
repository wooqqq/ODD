import 'package:flutter/material.dart';
import 'package:odd/modules/common/large_card.dart';

import '../../constants/appcolors.dart';

class AddressCard extends StatelessWidget {
  final String platform;
  final bool shadow;

  const AddressCard({
    Key? key,
    required this.platform,
    required this.shadow
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color platformColor;
    switch (platform) {
      case 'GS25':
        platformColor = AppColors.gsPrimary;
        break;
      case 'GS더프레시':
        platformColor = AppColors.freshPrimary;
        break;
      case 'wine25':
        platformColor = AppColors.winePrimary;
        break;
      default:
        platformColor = AppColors.grey;
    }

    return LargeCard(
      shadow: shadow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 주소 정보
          Row(
            children: [
              Image.asset(
                'assets/icons/location_icon.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                '대전 유성구 계룡로 105번길 20',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Divider(
            color: AppColors.lightgrey,
            height: 16,
          ),
          // 매장 정보
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: platformColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '선택매장',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                platform,
                style: TextStyle(
                  color: platformColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '덕명네오미아점',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
