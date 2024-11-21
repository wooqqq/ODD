import 'package:get/get.dart';
import '../../../apis/item_api.dart';
import '../models/sub.dart';

class SubController extends GetxController {
  final String platform;
  final String middle;
  final ItemApi _itemApi = ItemApi();

  SubController(this.platform, this.middle);

  var subs = <Sub>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubCategories();
  }

  // 소분류 호출
  Future<void> fetchSubCategories() async {
    isLoading.value = true;
    try {
      final fetchedSubs = await _itemApi.fetchSubs(platform, middle);
      if (fetchedSubs.isNotEmpty) {
        subs.value = [Sub(sub: "전체"), ...fetchedSubs];
      } else {
        errorMessage.value = '소분류 항목이 없습니다.';
        subs.clear();
      }
    } catch (e) {
      errorMessage.value = '서브 카테고리를 불러오는 중 오류가 발생했습니다: $e';
      subs.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
