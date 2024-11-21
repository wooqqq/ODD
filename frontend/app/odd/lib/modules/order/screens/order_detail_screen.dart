import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/main.dart';
import 'package:odd/constants/appcolors.dart';
import 'package:odd/modules/cart/controller/cart_controller.dart';
import 'package:odd/modules/common/default_layout.dart';
import 'package:odd/modules/common/image_card.dart';
import 'package:odd/modules/common/service_type_label.dart';
import 'package:odd/modules/order/controller/order_controller.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final int purchaseId;
  final int totalCount;

  const OrderDetailScreen({
    super.key,
    required this.purchaseId,
    required this.totalCount,
  });

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderController orderController = Get.put(OrderController());
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    orderController.fetchOrderDetail(widget.purchaseId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Image(
              image: AssetImage('assets/icons/back_icon.png'),
              width: 20,
              height: 20,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          const Expanded(
            child: Center(
              child: Text(
                '주문 상세',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Image(
              image: AssetImage('assets/icons/navbar/home_select.png'),
              width: 20,
              height: 20,
            ),
            onPressed: () {
              Get.offAll(() => MainApp());
            },
          ),
        ],
      ),
      child: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderController.orderDetail.isEmpty) {
          return const Center(child: Text("주문 상세 정보를 불러올 수 없습니다."));
        }

        final order = orderController.orderDetail;
        final formattedTotalPrice =
        NumberFormat('#,###').format(order['totalPrice']);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceTypeLabel(
                backgroundColor: orderController.secondaryColor.value,
                type: order['serviceType'] ?? '정보 없음',
                size: 'medium',
              ),
              const SizedBox(height: 16),
              Text(
                widget.totalCount == 1
                    ? '${order['items'][0]['itemName']} $formattedTotalPrice원'
                    : '${order['items'][0]['itemName']} 외 ${widget.totalCount - 1}건 $formattedTotalPrice원',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.lightgrey),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        color: AppColors.grey),
                    const SizedBox(width: 4),
                    Text(
                      order['platform'] ?? '플랫폼 정보 없음',
                      style: TextStyle(
                        fontSize: 16,
                        color: orderController.primaryColor.value,
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
              ),
              const SizedBox(height: 12),
              Text(
                '주문일시     ${order['purchaseDate'] ?? '정보 없음'}',
                style: const TextStyle(fontSize: 14, color: AppColors.grey),
              ),
              const Divider(
                  height: 24, thickness: 1, color: AppColors.lightgrey),

              // 주문 상품 목록
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '주문상품',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.lightgrey),
                    ),
                    child: Column(
                      children: [
                        for (var item in order['items'] ?? [])
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ImageCard(
                                      s3url: item['s3url'],
                                      length: 50,
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['itemName'] ?? '상품명 없음',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${NumberFormat('#,###').format(item['price'])}원 X${item['count']}개',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: OutlinedButton(
                  onPressed: () {
                    for (var item in order['items']) {
                      cartController.addItem(
                        item['itemId'],
                        item['itemName'],
                        item['price'],
                        item['count'],
                        order['serviceType'],
                        order['platform'],
                        item['s3url'],
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    side: const BorderSide(color: AppColors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    '장바구니 다시 담기',
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Divider(
                  height: 24, thickness: 1, color: AppColors.lightgrey),

              // 총 결제 금액 표시
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '총 결제 금액',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$formattedTotalPrice원',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
