import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/appcolors.dart';
import '../../common/default_layout.dart';
import '../controller/notification_controller.dart';
import '../widgets/notificiation_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController = Get.put(NotificationController());

    return DefaultLayout(
      header: Row(
        children: [
          IconButton(
            icon: Image.asset(
              'assets/icons/back_icon.png',
              width: 20,
              height: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Center(
              child: Text(
                '알림',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
      child: Obx(() {
        if (notificationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (notificationController.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/notification/empty_notification.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 8),
                const Text(
                  '최근 7일간 알림이 없습니다',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkgrey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: notificationController.notifications.length,
          itemBuilder: (context, index) {
            final notification = notificationController.notifications[index];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: NotificationCard(
                    notification: notification,
                  ),
                ),
                if (index < notificationController.notifications.length - 1)
                  const Divider(
                    color: AppColors.lightgrey,
                    height: 1,
                  ),
              ],
            );
          },
        );
      }),
    );
  }
}
