import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/modules/common/default_layout.dart';
import '../../../constants/appcolors.dart';
import '../../common/Item_preview.dart';
import '../../common/cart_button.dart';
import '../../item/models/item.dart';
import '../controller/home_controller.dart';
import '../controller/recommend_controller.dart';

class RecommendScreen extends StatefulWidget {
  final List<Item> itemList;
  final bool? isNotification;

  const RecommendScreen({
    Key? key,
    required this.itemList,
    this.isNotification,
  }) : super(key: key);

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  late List<Item> itemList;
  bool isLoading = true; // 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    itemList = widget.itemList;

    // isNotification이 true라면 timeRec 호출
    if (widget.isNotification == true) {
      fetchTimeRecData();
    } else {
      setState(() {
        isLoading = itemList.isEmpty;
      });
    }
  }

  // 알림 추천 데이터 로드
  Future<void> fetchTimeRecData() async {
    final recommendController = Get.find<RecommendController>();
    final newTimeRec = await recommendController.fetchTimeRec();

    setState(() {
      itemList = newTimeRec;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultLayout(
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
                    '${homeController.selectedPlatform}',
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
      child: GridView.builder(
        shrinkWrap: false,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16),
        itemCount: itemList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.55,
        ),
        itemBuilder: (context, index) {
          final item = itemList[index];
          return ItemPreview(
            isHome: false,
            size: 'medium',
            item: item,
          );
        },
      ),
    );
  }
}
