import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRecordController extends GetxController {
  var searchRecords = <String>[].obs; // 검색 기록 리스트

  @override
  void onInit() {
    super.onInit();
    loadSearchRecords();
  }

  // 검색 기록 불러오기
  void loadSearchRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchRecords.value = prefs.getStringList('searchRecords') ?? [];
  }

  // 검색 기록 추가
  void addSearchRecord(String record) async {
    if (searchRecords.contains(record)) {
      searchRecords.remove(record);
    }
    searchRecords.insert(0, record);

    if (searchRecords.length > 10) {
      searchRecords.removeLast();
    }

    await saveSearchRecords(); // 저장
  }

  // 검색 기록 저장
  Future<void> saveSearchRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchRecords', searchRecords);
  }

  // 검색 기록 삭제
  void deleteSearchRecord(String record) async {
    searchRecords.remove(record);
    await saveSearchRecords();
  }

  // 검색 기록 전체 삭제
  void clearSearchRecords() async {
    searchRecords.clear();
    await saveSearchRecords();
  }
}
