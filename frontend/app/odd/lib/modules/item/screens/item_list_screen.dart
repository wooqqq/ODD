import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/constants/appcolors.dart';
import 'package:odd/modules/common/default_layout.dart';
import '../../common/cart_button.dart';
import '../../common/drop_box.dart';
import '../../common/navbar.dart';
import '../../common/tab_button.dart';
import '../../home/controller/home_controller.dart';
import '../../common/Item_preview.dart';
import '../controller/item_list_controller.dart';
import '../controller/sub_controller.dart';
import '../controller/scroll_controller_manager.dart';

class ItemListScreen extends StatefulWidget {
  final String middle;
  final String platform;

  const ItemListScreen({
    Key? key,
    required this.middle,
    required this.platform,
  }) : super(key: key);

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  late ItemListController itemListController;
  late SubController subController;
  late ScrollControllerManager scrollControllerManager;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  void initializeControllers() {
    Get.delete<ItemListController>(tag: '${widget.platform}_${widget.middle}');
    itemListController = Get.put(
      ItemListController(widget.platform, widget.middle),
      tag: '${widget.platform}_${widget.middle}',
    );

    Get.delete<SubController>(tag: '${widget.platform}_${widget.middle}');
    subController = Get.put(
      SubController(widget.platform, widget.middle),
      tag: '${widget.platform}_${widget.middle}',
    );

    scrollControllerManager = Get.put(
      ScrollControllerManager(itemListController: itemListController),
      tag: '${widget.platform}_${widget.middle}_scroll',
    );
  }

  @override
  void dispose() {
    Get.delete<ScrollControllerManager>(tag: '${widget.platform}_${widget.middle}_scroll');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return DefaultLayout(
      // 상단바
      header: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/icons/back_icon.png',
                  width: 20,
                  height: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.middle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 48,
                child: Center(child: CartButton()),
              ),
            ],
          ),
        ],
      ),
      // 하단바
      bottom: Navbar(),
      child: Column(
        children: [
          // 소분류
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.lightgrey,
                  width: 1.0,
                ),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 13),
            child: SizedBox(
              height: 40,
              child: Center(
                child: Obx(() {
                  if (subController.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else if (subController.errorMessage.isNotEmpty) {
                    return Text(subController.errorMessage.value);
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(subController.subs.length, (index) {
                          final subCategory = subController.subs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: TabButton(
                              title: subCategory.sub,
                              isSelected: selectedIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                                itemListController.updateSub(subCategory.sub);
                              },
                              selectedColor: homeController.primaryColor.value,
                              unselectedColor: AppColors.white,
                              selectedTextColor: AppColors.white,
                              unselectedTextColor: AppColors.darkgrey,
                            ),
                          );
                        }),
                      ),
                    );
                  }
                }),
              ),
            ),
          ),

          Expanded(
            child: CustomScrollView(
              controller: scrollControllerManager.scrollController,
              slivers: [
                // 정렬/필터
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Text(
                          '상품 ${itemListController.totalItems.value}개',
                          style: const TextStyle(fontSize: 16, color: AppColors.grey),
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            DropBox(
                              filterList: const ['추천순', '낮은 가격순', '높은 가격순'],
                              onChanged: (value) {
                                itemListController.updateSort(
                                    value == '낮은 가격순' ? '낮은' :
                                    value == '높은 가격순' ? '높은' : '추천'
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            DropBox(
                              filterList: const ['전체', '배달', '픽업'],
                              onChanged: (value) {
                                itemListController.updateFilter(
                                    value == '배달' ? '배달' :
                                    value == '픽업' ? '픽업' : '전체'
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 상품 리스트
                Obx(() {
                  if (itemListController.isLoading.value && itemListController.items.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (itemListController.errorMessage.isNotEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(child: Text(itemListController.errorMessage.value)),
                    );
                  } else if (itemListController.items.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(child: Text("상품이 없습니다")),
                    );
                  } else {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final item = itemListController.items[index];
                            return ItemPreview(
                              isHome: false,
                              size: 'medium',
                              item: item,
                            );
                          },
                          childCount: itemListController.items.length,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          childAspectRatio: 0.55,
                        ),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
