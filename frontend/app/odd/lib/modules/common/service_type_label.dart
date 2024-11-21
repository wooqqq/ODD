import 'package:flutter/material.dart';
import 'package:odd/constants/appcolors.dart';

class ServiceTypeLabel extends StatelessWidget {
  final Color backgroundColor;
  final String type;
  final String size;

  const ServiceTypeLabel({
    required this.backgroundColor,
    required this.type,
    required this.size,
    Key? key,
  }) : super(key: key);

  double _getFontSize() {
    switch (size) {
      case 'small':
        return 8.0;
      case 'medium':
        return 12.0;
      case 'large':
        return 16.0;
      default:
        return 12.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: AppColors.black,
          fontSize: _getFontSize(),
        ),
      ),
    );
  }
}
