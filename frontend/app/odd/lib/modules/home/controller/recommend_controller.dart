import 'package:get/get.dart';
import '../../../apis/recommend_api.dart';
import '../../item/models/item.dart';

class RecommendController extends GetxController {
  final RecommendApi recommendApi = RecommendApi();

  var platform = ''.obs;
  var isLoading = true.obs;
  var favCategory = <Item>[].obs;
  var purchaseCycle = <Item>[].obs;
  var timeRec = <Item>[].obs;
  var recentItems = <Item>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataForPlatform(platform.value);
  }

  void fetchDataForPlatform(String platform) {
    if (platform == 'GS25') {
      fetchGS25Section(platform);
    } else if (platform == 'GS더프레시') {
      fetchGSfreshSection(platform);
    } else if (platform == 'wine25') {
      fetchWineSection(platform);
    } else {
      fetchHomeSection(platform);
    }
  }

  void changePlatform(String newPlatform) {
    if (platform.value != newPlatform) {
      isLoading.value = true;
      favCategory.clear();
      purchaseCycle.clear();
      timeRec.clear();
      recentItems.clear();

      platform.value = newPlatform;
      fetchDataForPlatform(newPlatform);
    }
  }

  // 홈 콘텐츠 호출 (선호 카테고리 + 최근 구매한 상품)
  Future<void> fetchHomeSection(String platform) async {
    isLoading.value = true;
    try {
      final favJson = await recommendApi.getFavCategoryHome();
      final recentJson = await recommendApi.getRecentItems(platform);

      favCategory.value =
          favJson?.map((json) => Item.fromJson(json)).toList() ?? [];
      recentItems.value =
          recentJson?.map((json) => Item.fromJson(json)).toList() ?? [];
    } catch (e) {
      print('홈 추천상품 요청 실패: $e');
      favCategory.value = [];
      recentItems.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // GS25 콘텐츠 호출 (선호 카테고리 + 시간대 추천)
  Future<void> fetchGS25Section(String platform) async {
    isLoading.value = true;
    try {
      final favJson = await recommendApi.getFavCategory(platform);
      final timeRecJson = await recommendApi.getTimeRec();

      favCategory.value =
          favJson?.map((json) => Item.fromJson(json)).toList() ?? [];
      timeRec.value =
          timeRecJson?.map((json) => Item.fromJson(json)).toList() ?? [];
    } catch (e) {
      print('GS25 추천상품 요청 실패: $e');
      favCategory.value = [];
      timeRec.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // GS더프레시 콘텐츠 호출 (선호 카테고리 + 주기별 추천)
  Future<void> fetchGSfreshSection(String platform) async {
    isLoading.value = true;
    try {
      final favJson = await recommendApi.getFavCategory(platform);
      final purchaseCycleJson = await recommendApi.getPurchaseCycle(platform);

      favCategory.value =
          favJson?.map((json) => Item.fromJson(json)).toList() ?? [];
      purchaseCycle.value =
          purchaseCycleJson?.map((json) => Item.fromJson(json)).toList() ?? [];
    } catch (e) {
      print('GS더프레시 추천상품 요청 실패: $e');
      favCategory.value = [];
      purchaseCycle.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // 와인25 콘텐츠 호출 (선호 카테고리)
  Future<void> fetchWineSection(String platform) async {
    isLoading.value = true;
    try {
      final favJson = await recommendApi.getFavCategory(platform);
      favCategory.value =
          favJson?.map((json) => Item.fromJson(json)).toList() ?? [];
    } catch (e) {
      print('와인 추천상품 요청 실패: $e');
      favCategory.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  // 시간대 알고리즘 호출
  Future<List<Item>> fetchTimeRec() async {
    try {
      final timeRecJson = await recommendApi.getTimeRec();
      return timeRecJson?.map((json) => Item.fromJson(json)).toList() ?? [];
    } catch (e) {
      print('timeRec 호출 실패: $e');
      return [];
    }
  }
}