import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../constants/appcolors.dart';
import '../../item/models/item.dart';
import '../controller/cart_controller.dart';
import 'count_button.dart';
import 'package:odd/modules/common/custom_button.dart';

class CartModal extends StatefulWidget {
  final Item item;

  const CartModal({
    super.key,
    required this.item,
  });

  @override
  _CartModalState createState() => _CartModalState();
}

class _CartModalState extends State<CartModal> {
  final CartController cartController = Get.find<CartController>();
  final NumberFormat currencyFormat = NumberFormat('#,###');
  int count = 1;

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    setState(() {
      if (count > 1) count--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isPickupAvailable = widget.item.serviceType.contains('픽업');
    final bool isDeliveryAvailable = widget.item.serviceType.contains('배달');

    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                widget.item.itemName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${currencyFormat.format(widget.item.price)}원',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(
                color: AppColors.lightgrey,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('수량', style: TextStyle(fontSize: 18)),
                  CountButton(
                    count: count,
                    onIncrement: increment,
                    onDecrement: decrement,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(
                color: AppColors.lightgrey,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('총 상품 금액', style: TextStyle(fontSize: 18)),
                  Text(
                    '${currencyFormat.format(widget.item.price * count)}원',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          color: AppColors.white,
          child: SizedBox(
            height: 65,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/icons/heart_icon.png',
                        width: 30,
                        height: 30,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: CustomButton(
                      text: '픽업',
                      isDisabled: !isPickupAvailable,
                      onPressed: () {
                        cartController.addItem(
                          widget.item.itemId,
                          widget.item.itemName,
                          widget.item.price,
                          count,
                          '픽업',
                          widget.item.platform,
                          widget.item.s3url,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: CustomButton(
                      text: '배달',
                      isDisabled: !isDeliveryAvailable,
                      onPressed: () {
                        cartController.addItem(
                          widget.item.itemId,
                          widget.item.itemName,
                          widget.item.price,
                          count,
                          '배달',
                          widget.item.platform,
                          widget.item.s3url,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
