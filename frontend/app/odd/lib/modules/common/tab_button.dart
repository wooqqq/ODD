import 'package:flutter/material.dart';
import '../../constants/appcolors.dart';

class TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color selectedBorderColor;
  final Color unselectedBorderColor;
  final String? imagePath;

  const TabButton({
    super.key,
    required this.title,
    required this.isSelected,
    this.selectedColor = AppColors.darkgrey,
    this.unselectedColor = AppColors.white,
    this.selectedTextColor = AppColors.white,
    this.unselectedTextColor = AppColors.darkgrey,
    this.selectedBorderColor = Colors.transparent,
    this.unselectedBorderColor = Colors.transparent,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? selectedBorderColor : unselectedBorderColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            if (imagePath != null && imagePath!.isNotEmpty)
              Image.asset(
                imagePath!,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? selectedTextColor : unselectedTextColor,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
