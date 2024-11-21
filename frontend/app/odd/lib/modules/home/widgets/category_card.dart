import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/large_card.dart';
import '../controller/home_controller.dart';
import '../../item/screens/item_list_screen.dart';
import 'category_button.dart';
import 'category_modal.dart';

class CategoryCard extends StatelessWidget {
  final HomeController homeController;
  final String platform;

  const CategoryCard({
    Key? key,
    required this.homeController,
    required this.platform,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => LargeCard(
        child: SizedBox(
          height: 180,
          child: CustomScrollView(
            scrollDirection: Axis.horizontal,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(4.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if (index == 0) {
                        return CategoryButton(
                          text: '카테고리',
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => CategoryModal(platform: platform),
                            );
                          },
                        );
                      } else {
                        final item = homeController.filteredMiddle[index - 1];
                        return CategoryButton(
                          text: item.middle,
                          s3url: item.s3url,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemListScreen(
                                  middle: item.middle,
                                  platform: platform,
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                    childCount: homeController.filteredMiddle.length + 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

