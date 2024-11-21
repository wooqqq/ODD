import 'package:flutter/material.dart';
import '../../../constants/appcolors.dart';

class SearchRecord extends StatelessWidget {
  final String text;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const SearchRecord({
    Key? key,
    required this.text,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: AppColors.grey,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onDelete,
              child: Image.asset(
                'assets/icons/close_grey_icon.png',
                width: 16,
                height: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
