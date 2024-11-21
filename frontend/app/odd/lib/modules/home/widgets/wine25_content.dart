import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/item_preview.dart';
import '../../common/address_card.dart';
import '../../common/large_card.dart';
import '../../user/controller/login_controller.dart';
import '../controller/home_controller.dart';
import '../controller/recommend_controller.dart';
import 'category_card.dart';

class Wine25Content extends StatelessWidget {
  final String platform;

  const Wine25Content({
    Key? key,
    required this.platform,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    final recommendController = Get.put(RecommendController());
    final homeController = Get.find<HomeController>();

    return Column(
      children: [
        // 주소 선택 카드
        AddressCard(
          shadow: false,
          platform: platform,
        ),
        const SizedBox(height: 13),

        // 카테고리 선택 카드
        CategoryCard(
          homeController: homeController,
          platform: platform,
        ),
        const SizedBox(height: 13),

        // wine25 추천 리스트
        Obx(() {
          if (recommendController.isLoading.value || loginController.nickname.value == '') {
            return const Center(child: CircularProgressIndicator());
          }

          final favCategory = recommendController.favCategory;

          return favCategory.isNotEmpty
              ? LargeCard(
            title: '${loginController.nickname}님, 이 상품은 어떠세요? 🎁',
            itemList: favCategory,
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: favCategory.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 110,
                        child: ItemPreview(
                          isHome: false,
                          size: 'small',
                          item: item,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          )
              : const SizedBox();
        }),
      ],
    );
  }
}
