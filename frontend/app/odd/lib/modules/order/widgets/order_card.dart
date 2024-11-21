import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:odd/constants/appcolors.dart';
import 'package:odd/modules/common/image_card.dart';
import 'package:odd/modules/common/service_type_label.dart';
import 'package:odd/modules/order/controller/order_controller.dart';
import 'package:odd/modules/order/screens/order_detail_screen.dart';

class OrderCard extends StatelessWidget {
  final int purchaseId;
  final String orderDate;
  final String productName;
  final int price;
  final String serviceType;
  final String platform;
  final String s3url;
  final int totalCount;

  const OrderCard({
    super.key,
    required this.purchaseId,
    required this.orderDate,
    required this.productName,
    required this.price,
    required this.serviceType,
    required this.platform,
    required this.s3url,
    required this.totalCount
  });

  String getStoreName(String platform) {
    switch (platform) {
      case 'GS25':
        return 'GS25';
      case 'GS더프레시':
        return 'GS더프레시';
      case 'wine25':
        return 'wine25';
      default:
        return 'GS25';
    }
  }

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.find<OrderController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '주문일자 $orderDate',
                style: const TextStyle(color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '$serviceType이 완료되었습니다.',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageCard(
                s3url: s3url,
                length: 120
              ),
              const SizedBox(width: 14),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ServiceTypeLabel(
                        backgroundColor: controller.secondaryColor.value,
                        type: serviceType,
                        size: 'medium',
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            getStoreName(platform),
                            style: TextStyle(
                              color: controller.primaryColor.value,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
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
                      Text(
                        totalCount > 1
                          ? '$productName 외 ${totalCount - 1}건'
                          : productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(
                      color: AppColors.grey, fontSize: 17),
                      ),
                      Text(
                        '${NumberFormat('#,###').format(price)}원',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.to(() => OrderDetailScreen(
                      purchaseId: purchaseId,
                      totalCount: totalCount
                    ));
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text(
                    '주문상세 내역보기',
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}