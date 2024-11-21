import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/constants/appcolors.dart';
import 'package:odd/modules/common/default_layout.dart';
import 'package:odd/modules/order/controller/order_controller.dart';
import 'package:odd/modules/order/widgets/order_card.dart';
import 'package:odd/modules/order/widgets/order_dropbox.dart';
import 'package:odd/modules/order/widgets/order_tabbar.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderController controller = Get.put(OrderController());
  final List<String> filterList = ['전체', '픽업', '배달'];
  String selectedFilter = '전체';

  // ScrollController 추가
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // 스크롤 리스너 추가
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          !controller.isLoading.value &&
          !controller.isLastPage.value) {
        controller.fetchOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      header: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                '주문내역',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() => Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.lightgrey,
                  width: 1.0,
                ),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 13),
            child: OrderTabBar(
              selectedPlatform: controller.selectedPlatform.value,
              onTabSelected: (platform) {
                controller.changePlatform(platform);
                setState(() {
                  selectedFilter = '전체';
                });
                controller.changeServiceType('전체');
              },
              primaryColor: controller.primaryColor.value,
              secondaryColor: controller.secondaryColor.value,
            ),
          )),
          Expanded(
            child: Obx(() {
              if (controller.orders.isEmpty && controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (controller.orders.isEmpty) {
                return const Center(
                  child: Text('표시할 주문 내역이 없습니다.'),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: controller.orders.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => Text(
                            '총 ${controller.totalPurchases.value} 개',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.darkgrey,
                            ),
                          )),
                          UserDropBox(
                            filterList: filterList,
                            selectedFilter: selectedFilter,
                            onChanged: (filter) {
                              setState(() {
                                selectedFilter = filter;
                              });
                              controller.changeServiceType(selectedFilter);
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  final order = controller.orders[index - 1];
                  return Column(
                    children: [
                      OrderCard(
                        purchaseId: order['purchaseId'],
                        orderDate: order['purchaseDate'],
                        productName: order['firstProductName'],
                        price: order['totalPrice'],
                        serviceType: order['serviceType'],
                        platform: order['platform'],
                        s3url: order['s3url'],
                        totalCount: order['totalCount']
                      ),
                      const Divider(
                        thickness: 4,
                        color: AppColors.background,
                      ),
                    ],
                  );
                },
              );
            }),
          )

        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
