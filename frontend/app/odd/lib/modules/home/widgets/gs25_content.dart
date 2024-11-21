import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/item_preview.dart';
import '../../common/address_card.dart';
import '../../common/large_card.dart';
import '../../user/controller/login_controller.dart';
import '../controller/recommend_controller.dart';
import '../controller/home_controller.dart';
import 'category_card.dart';

class GS25Content extends StatelessWidget {
  final String platform;

  const GS25Content({
    super.key,
    required this.platform,
  });

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

        // 카테고리 선택 박스
        CategoryCard(
          homeController: homeController,
          platform: platform,
        ),
        const SizedBox(height: 13),

        // GS25 추천 리스트
        Obx(() {
          if (recommendController.isLoading.value ||
              loginController.nickname.value == '') {
            return const Center(child: CircularProgressIndicator());
          }

          final favCategory = recommendController.favCategory;
          final timeRec = recommendController.timeRec;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (timeRec.isNotEmpty)
                Column(
                  children: [
                    LargeCard(
                      title: '지금 이 시간, 추천드리는 상품! ⏰',
                      itemList: timeRec,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: timeRec
                                .sublist(
                                    0, timeRec.length > 5 ? 5 : timeRec.length)
                                .map((item) {
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
                    ),
                    const SizedBox(height: 13),
                  ],
                )
              else
                const SizedBox(),
              if (favCategory.isNotEmpty)
                LargeCard(
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
                            .sublist(0,
                                favCategory.length > 5 ? 5 : favCategory.length)
                            .map((item) {
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
              else
                const SizedBox(),
            ],
          );
        }),
      ],
    );
  }
}
