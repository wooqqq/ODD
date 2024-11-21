import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/item_preview.dart';
import '../../common/large_card.dart';
import '../../user/controller/login_controller.dart';
import '../controller/recommend_controller.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    final recommendController = Get.put(RecommendController());

    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: LargeCard(
                title: '나만의 냉장고',
                child: Center(
                  child: Image(
                    image: AssetImage('assets/images/home/fridge.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            SizedBox(width: 13),
            Expanded(
              child: LargeCard(
                title: '주변 매장 찾기',
                child: Center(
                  child: Image(
                    image: AssetImage('assets/images/home/near_store.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),

        // 최근 구매한 상품 표시
        Obx(() {
          if (recommendController.isLoading.value || loginController.nickname.value == '') {
            return const Center(child: CircularProgressIndicator());
          }

          final recentItems = recommendController.recentItems;

          return recentItems.isNotEmpty
              ? LargeCard(
            title: '${loginController.nickname}님이 최근 구매한 상품입니다.',
            itemList: recentItems,
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: recentItems
                      .sublist(0, recentItems.length > 5 ? 5 : recentItems.length)
                      .map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 110,
                        child: ItemPreview(
                          isHome: true,
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
        const SizedBox(height: 13),

        // 카테고리 추천 상품 표시
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
                  children: favCategory
                      .sublist(0, favCategory.length > 5 ? 5 : favCategory.length)
                      .map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
                        width: 110,
                        child: ItemPreview(
                          isHome: true,
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

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            '지금은 추천 상품이 없습니다.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            '다른 카테고리를 확인해 보세요!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
