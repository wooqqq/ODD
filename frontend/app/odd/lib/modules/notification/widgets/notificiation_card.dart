import 'package:flutter/material.dart';
import 'package:odd/modules/home/screens/recommend_screen.dart';
import '../../../constants/appcolors.dart';
import '../../item/screens/item_detail_screen.dart';
import '../models/notification.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SizedBox(
        height: 70,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    notification.platform == 'GS25'
                        ? 'assets/images/notification/GS25_logo.png'
                        : notification.platform == 'GS더프레시'
                        ? 'assets/images/notification/GSfresh_logo.png'
                        : 'assets/images/notification/GS25_logo.png',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    notification.content,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.date,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: AppColors.darkgrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        if (notification.platform == 'GS더프레시' && notification.itemId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailScreen(
                itemId: notification.itemId!,
                platform: notification.platform,
              ),
            ),
          );
        } else if (notification.platform == 'GS25') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RecommendScreen(
                itemList: [],
                isNotification: true,
              ),
            ),
          );
        }
      },
    );
  }
}
