import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../common/image_card.dart';
import '../controller/cart_controller.dart';
import 'count_button.dart';

class CartItem extends StatelessWidget {
  final String itemId;
  final String itemName;
  final String s3url;
  final int price;
  final int count;
  final VoidCallback onDelete;

  const CartItem({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.s3url,
    required this.price,
    required this.count,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final NumberFormat currencyFormat = NumberFormat('#,###');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageCard(
                s3url: s3url,
                length: 80,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 8.0),
                  child: Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Image.asset(
                  'assets/icons/close_icon.png',
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CountButton(
                count: count,
                onIncrement: () =>
                    cartController.updateItemCount(itemId, count + 1),
                onDecrement: () => cartController.updateItemCount(
                    itemId, count > 1 ? count - 1 : 1),
              ),
              Text(
                '${currencyFormat.format(price * count)}원',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
