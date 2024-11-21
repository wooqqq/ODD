import 'package:flutter/material.dart';
import '../../constants/appcolors.dart';
import '../home/screens/recommend_screen.dart';
import '../item/models/item.dart';

class LargeCard extends StatelessWidget {
  final Color backgroundColor;
  final String? title;
  final List<Item>? itemList;
  final bool? shadow;
  final Widget child;

  const LargeCard({
    required this.child,
    this.title,
    this.itemList,
    this.shadow = false,
    this.backgroundColor = AppColors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: shadow == true
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (itemList != null)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                              RecommendScreen(
                                itemList: itemList!
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Text(
                            '더보기',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Image.asset(
                            'assets/icons/more_icon.png',
                            width: 16,
                            height: 16,
                          )

                        ],
                      ),
                    ),
                ],
              ),
            ),
          child,
        ],
      ),
    );
  }
}
