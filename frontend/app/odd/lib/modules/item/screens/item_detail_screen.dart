import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:odd/modules/common/custom_button.dart';
import 'package:odd/modules/common/default_layout.dart';
import 'package:odd/modules/common/image_card.dart';
import 'package:odd/modules/common/service_type_label.dart';
import '../../../constants/appcolors.dart';
import '../../cart/widgets/cart_modal.dart';
import '../../common/cart_button.dart';
import '../controller/item_detail_controller.dart';
import '../widgets/info_section.dart';

class ItemDetailScreen extends StatelessWidget {
  final String itemId;
  final String platform;

  const ItemDetailScreen({
    super.key,
    required this.itemId,
    required this.platform,
  });

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'GS25':
        return AppColors.gsSecondary;
      case 'GS더프레시':
        return AppColors.freshSecondary;
      case 'wine25':
        return AppColors.wineSecondary;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormat = NumberFormat('#,###');
    // 상품 인스턴스 초기화
    Get.delete<ItemDetailController>();
    final ItemDetailController controller =
        Get.put(ItemDetailController(itemId, platform));

    return Obx(() {
      // 로딩 상태 처리
      if (controller.isLoading.value) {
        return const Scaffold(
          backgroundColor: AppColors.white,
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (controller.errorMessage.isNotEmpty) {
        return Scaffold(
          body: Center(child: Text(controller.errorMessage.value)),
        );
      }

      final item = controller.item.value!;
      return DefaultLayout(
        // 상단바
        header: Row(
          children: [
            IconButton(
              icon: Image.asset(
                'assets/icons/back_icon.png',
                width: 20,
                height: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            CartButton(),
          ],
        ),
        // 장바구니 담기 하단바
        bottom: Container(
          height: 65,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: IconButton(
                  icon: Image.asset(
                    'assets/icons/heart_icon.png',
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomButton(
                  text: '장바구니 담기',
                  onPressed: () {
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
                ),
              ),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ImageCard(
                    s3url: item.s3url,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  item.itemName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Wrap(
                  spacing: 8.0,
                  children: item.serviceType.map((type) {
                    return ServiceTypeLabel(
                      backgroundColor: _getPlatformColor(item.platform),
                      type: type,
                      size: 'large',
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28.0, vertical: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${currencyFormat.format(item.price)}원',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Divider(
                color: AppColors.background,
                thickness: 4,
              ),
              const InfoSection(
                title: '이용안내',
                description: 'GS25 오프라인 매장의 할인/증정 행사와 내용이 다를 수 있습니다.',
              ),
              const Divider(
                color: AppColors.background,
                thickness: 4,
              ),
              const InfoSection(
                title: '교환/반품',
                description: '상온에 노출되거나, 품질이 변질될 수 있는 상품, 내용물이 판매 당시 상태와 다르다고 판단된 상품, 포장이 훼손된 상품, 고객님의 일부 소비에 따라 상품의 가치가 감소한 경우, 특가로 할인 중인 모든 마감할인 상품은 교환 및 환불이 불가능합니다.',
              ),
            ],
          ),
        ),
      );
    });
  }
}
