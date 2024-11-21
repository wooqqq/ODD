import 'package:get/get.dart';
import 'package:odd/apis/search_api.dart';
import 'package:odd/modules/item/models/item.dart';

class SearchResultController extends GetxController {
  final searchApi = SearchApi();

  var searchResults = <dynamic>[].obs;
  var errorMessage = ''.obs;
  var isLoading = false.obs;
  var isLastPage = false.obs;
  var page = 0.obs;

  // 검색 결과 요청 메서드
  Future<void> searchItems(
    String keyword,
    String platform, {
    int size = 20,
    String sort = 'string',
  }) async {
    if (isLoading.value || isLastPage.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    print(
        "Before API request - Page: ${page.value}, isLastPage: ${isLastPage.value}");

    try {
      // API 요청
      final response = await searchApi.getSearchResult(
        keyword,
        platform,
        page.value,
        size,
        sort: sort,
      );

      final List<dynamic> results = response['content'];
      final bool responseLast = response['last'];

      if (results.isNotEmpty) {
        if (page.value == 0) {
          searchResults.clear();
        }

        // 검색 결과 추가
        searchResults
            .addAll(results.map((data) => Item.fromJson(data)).toList());

        if (!responseLast) {
          page.value++;
        } else {
          isLastPage.value = true;
        }
      }
    } catch (e) {
      errorMessage.value = '오류가 발생했습니다. 다시 시도해 주세요.';
    } finally {
      isLoading.value = false;
    }
  }

  // 검색 결과 초기화
  void clearResults() {
    searchResults.clear();
    page.value = 0;
    isLastPage.value = false;
    errorMessage.value = '';
  }
}
