import 'package:flutter/material.dart';
import '../../common/tab_button.dart';

class OrderTabBar extends StatelessWidget {
  final String selectedPlatform;
  final Function(String platform) onTabSelected;
  final Color primaryColor;
  final Color secondaryColor;

  const OrderTabBar({
    super.key,
    required this.selectedPlatform,
    required this.onTabSelected,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TabButton(
            title: 'GS25',
            isSelected: selectedPlatform == 'GS25',
            onTap: () => onTabSelected('GS25'),
            selectedColor: primaryColor,
          ),
          const SizedBox(width: 8),
          TabButton(
            title: 'GS더프레시',
            isSelected: selectedPlatform == 'GS더프레시',
            onTap: () => onTabSelected('GS더프레시'),
            selectedColor: primaryColor,
          ),
          const SizedBox(width: 8),
          TabButton(
            title: 'wine25',
            isSelected: selectedPlatform == 'wine25',
            onTap: () => onTabSelected('wine25'),
            selectedColor: primaryColor,
          ),
        ],
      ),
    );
  }
}
