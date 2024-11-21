import 'package:flutter/material.dart';
import '../../../constants/appcolors.dart';

class CountButton extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CountButton({
    Key? key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: AppColors.grey,
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                'assets/icons/decrement_icon.png',
                width: 20,
                height: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                'assets/icons/increment_icon.png',
                width: 20,
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
