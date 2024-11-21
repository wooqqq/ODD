import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/appcolors.dart';
import '../../common/image_card.dart';
import '../controller/home_controller.dart';
import '../../item/screens/item_list_screen.dart';

class CategoryModal extends StatelessWidget {
  final String platform;

  const CategoryModal({
    Key? key,
    required this.platform,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 헤더
          Row(
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/icons/close_icon.png',
                  width: 20,
                  height: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    platform,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20.0),
          // 카테고리 리스트 출력
          Expanded(
            child: Obx(() {
              if (homeController.middle.isEmpty) {
                return const Center(child: Text('카테고리가 없습니다.'));
              }

              // 중분류 리스트
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                itemCount: homeController.middle.length,
                itemBuilder: (context, index) {
                  final category = homeController.middle[index];

                  // 상품 리스트로 이동
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemListScreen(
                            middle: category.middle,
                            platform: platform,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        ImageCard(
                          s3url: category.s3url,
                          length: 60,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            category.middle,
                            style: const TextStyle(fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
