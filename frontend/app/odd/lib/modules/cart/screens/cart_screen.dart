import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:odd/modules/cart/widgets/cart_pay_modal.dart';
import '../../../constants/appcolors.dart';
import '../../common/address_card.dart';
import '../../common/custom_button.dart';
import '../controller/cart_controller.dart';
import '../widgets/cart_item.dart';
import '../widgets/cart_tab_bar.dart';
import '../../common/default_layout.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.find<CartController>();
  final NumberFormat currencyFormat = NumberFormat('#,###');
  final CartPayModal cartPayModal = CartPayModal();

  String selectedPlatform = 'GS25';
  String selectedServiceType = '픽업';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
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
            child: Center(
              child: Text(
                '장바구니',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
      bottom: Obx(() {
        final items = cartController.groupedCartItems[selectedPlatform]
                ?[selectedServiceType] ??
            [];
        final int totalAmount = cartController.calculateSelectedType(
            selectedPlatform, selectedServiceType);

        return items.isNotEmpty
            ? Container(
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
                child: CustomButton(
                  text: '${currencyFormat.format(totalAmount)}원 주문하기',
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  onPressed: () {
                    cartPayModal.showCartPayConfirmationDialog(
                        context, selectedPlatform, selectedServiceType);
                  },
                ),
              )
            : const SizedBox.shrink();
      }),
      child: Column(
        children: [
          // 탭 바
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.lightgrey,
                  width: 1.0,
                ),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 13),
            child: CartTabBar(
              selectedPlatform: selectedPlatform,
              selectedServiceType: selectedServiceType,
              onTabSelected: (platform, serviceType) {
                setState(() {
                  selectedPlatform = platform;
                  selectedServiceType = serviceType;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text.rich(
                  TextSpan(
                    text: '장바구니 상품은 ',
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '7일간',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkgrey,
                        ),
                      ),
                      TextSpan(
                        text: '만 보관합니다.',
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => cartController.clearCart(selectedPlatform, selectedServiceType),
                  child: const Text(
                    '전체삭제',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final items = cartController.groupedCartItems[selectedPlatform]
                      ?[selectedServiceType] ??
                  [];

              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/cart/empty_cart.png',
                        width: 120,
                        height: 120,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '장바구니가 비었어요!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: AppColors.darkgrey,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: AddressCard(
                          shadow: true,
                          platform: selectedPlatform,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: items.asMap().entries.map((entry) {
                          int index = entry.key;
                          var item = entry.value;
                          return Column(
                            children: [
                              CartItem(
                                itemId: item['itemId'],
                                itemName: item['itemName'],
                                s3url: item['s3url'],
                                price: item['price'],
                                count: item['count'],
                                onDelete: () =>
                                    cartController.removeItem(item['itemId']),
                              ),
                              if (index < items.length - 1)
                                const Divider(
                                  color: AppColors.lightgrey,
                                  height: 16,
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                      const Divider(
                        color: AppColors.background,
                        thickness: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '총 결제 금액',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '${currencyFormat.format(cartController.calculateSelectedType(selectedPlatform, selectedServiceType))}원',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}