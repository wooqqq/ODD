import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:odd/modules/common/service_type_label.dart';
import '../../constants/appcolors.dart';
import '../cart/widgets/cart_modal.dart';
import 'image_card.dart';
import '../item/models/item.dart';
import '../item/screens/item_detail_screen.dart';

class ItemPreview extends StatelessWidget {
  final bool isHome;
  final String size;
  final Item item;

  const ItemPreview(
      {super.key,
      required this.isHome,
      required this.size,
      required this.item});

  // 플랫폼에 따른 Primary와 Secondary 색상 선택
  Map<String, Color> _getPlatformColors(String platform) {
    switch (item.platform) {
      case 'GS25':
        return {
          'primary': AppColors.gsPrimary,
          'secondary': AppColors.gsSecondary,
        };
      case 'GS더프레시':
        return {
          'primary': AppColors.freshPrimary,
          'secondary': AppColors.freshSecondary,
        };
      case 'wine25':
        return {
          'primary': AppColors.winePrimary,
          'secondary': AppColors.wineSecondary,
        };
      default:
        return {
          'primary': Colors.grey,
          'secondary': Colors.grey,
        };
    }
  }

  // 아이콘 사이즈
  double _getIconSize() {
    switch (size) {
      case 'small':
        return 16.0;
      case 'medium':
        return 20.0;
      default:
        return 20.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getPlatformColors(item.platform);
    final iconSize = _getIconSize();
    final NumberFormat currencyFormat = NumberFormat('#,###');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ItemDetailScreen(
                  itemId: item.itemId,
                  platform: item.platform,
                ),
              ),
            );
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: ImageCard(
              s3url: item.s3url,
            ),
          ),
        ),

        const SizedBox(height: 4),

        // 플랫폼
        if (isHome)
          Text(
            item.platform,
            style: TextStyle(
              fontFamily: 'LogoFont',
              fontWeight: FontWeight.w700,
              color: colors['primary'],
              fontSize: 16,
            ),
          ),

        const SizedBox(height: 4),

        // 배달/픽업 구분 및 아이콘들
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              spacing: 4,
              children: item.serviceType.map((type) {
                return ServiceTypeLabel(
                  backgroundColor: colors['secondary'] ?? Colors.grey,
                  type: type,
                  size: size,
                );
              }).toList(),
            ),
            Row(
              children: [
                // 좋아요 버튼
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/icons/heart_icon.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),

                const SizedBox(width: 8),

                // 장바구니 담기 버튼
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return CartModal(item: item);
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/icons/bag_icon.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 4),

        // 상품명
        Text(
          item.itemName,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.grey,
          ),
        ),

        const SizedBox(height: 4),

        // 가격
        Text(
          '${currencyFormat.format(item.price)}원',
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        // 구매 횟수
        if (item.purchaseCount != null)
          Text(
            '${item.purchaseCount}회 구매한 상품',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.notice,
            ),
          ),
      ],
    );
  }
}
