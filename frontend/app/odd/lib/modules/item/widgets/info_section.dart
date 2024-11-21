import 'package:flutter/material.dart';
import '../../../constants/appcolors.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final String description;

  const InfoSection({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.grey,
          collapsedIconColor: AppColors.grey,
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
