import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/apis/search_api.dart';
import 'package:odd/modules/common/Item_preview.dart';
import 'package:odd/modules/common/tab_button.dart';
import 'package:odd/modules/item/screens/item_detail_screen.dart';
import 'package:odd/modules/search/controller/search_result_controller.dart';
import 'package:odd/modules/search/widgets/search_record.dart';
import '../../../constants/appcolors.dart';
import '../../common/default_layout.dart';
import '../widgets/search_header.dart';
import '../controller/search_record_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchApi = SearchApi();
  final textController = TextEditingController();
  final searchRecordController = Get.put(SearchRecordController());
  final searchResultController = Get.find<SearchResultController>();

  var isSearching = false.obs;
  String selectedPlatform = 'GS25';
  final List<String> platforms = ['GS25', 'GS더프레시', 'wine25'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    searchResultController.clearResults();
  }

  void startSearch(String value,
      {String platform = 'GS25', String sort = 'string'}) {
    if (value.isNotEmpty) {
      setState(() {
        isSearching.value = true;
      });
      searchRecordController.addSearchRecord(value);
      searchResultController.searchItems(value, platform, sort: sort);
    }
  }

  List<String> autocompletes = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // 로딩 중이거나 마지막 페이지라면 요청하지 않음
        if (!searchResultController.isLoading.value &&
            !searchResultController.isLastPage.value) {
          searchResultController.searchItems(
              textController.text, selectedPlatform); // 더 많은 결과 요청
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      header: SearchHeader(
        textController: textController,
        onTextChanged: (value) async {
          if (value.isNotEmpty) {
            List<String> getAutocompletes =
                await searchApi.getAutocomplete(value);
            setState(() {
              autocompletes = getAutocompletes;
              isSearching.value = true;
            });
          } else {
            setState(() {
              autocompletes = [];
              isSearching.value = false;
            });
          }
          // 텍스트가 변경될 때마다 검색 결과 초기화
          searchResultController.clearResults();
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            // startSearch(value,
            //     platform: selectedPlatform, sort: 'string'); // 검색 실행
            setState(() {
              autocompletes = [];
            });

            searchResultController.clearResults(); // 결과 초기화
            searchResultController.searchItems(
                value, selectedPlatform); // 새 검색 시작
            searchRecordController.addSearchRecord(value); // 검색 기록 추가
          }
        },
        onClearPressed: () {
          textController.clear();
          searchResultController.clearResults(); // 검색 결과 초기화
          setState(() {
            autocompletes = [];
            isSearching.value = false;
          });
        },
        isSearching: isSearching.value,
      ),
      child: Column(
        children: [
          // 자동완성 목록
          if (autocompletes.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: autocompletes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.search),
                    title: Text(autocompletes[index]),
                    onTap: () {
                      textController.text = autocompletes[index];
                      searchResultController.clearResults(); // 결과 초기화
                      searchResultController.searchItems(
                          autocompletes[index], selectedPlatform);
                      setState(() {
                        autocompletes = [];
                      });
                    },
                  );
                },
              ),
            ),

          // 검색 기록
          if (!isSearching.value && autocompletes.isEmpty)
            Obx(() {
              if (searchRecordController.searchRecords.isNotEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '최근 검색어',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () =>
                                searchRecordController.clearSearchRecords(),
                            child: const Text(
                              '전체삭제',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Wrap(
                              spacing: 8.0,
                              children: searchRecordController.searchRecords
                                  .map((record) => SearchRecord(
                                      text: record,
                                      onDelete: () => searchRecordController
                                          .deleteSearchRecord(record),
                                      onTap: () {
                                        textController.text = record;
                                        searchRecordController.addSearchRecord(
                                            record); // 선택된 검색어를 맨 앞에 배치
                                        searchResultController.clearResults();
                                        startSearch(record,
                                            platform: selectedPlatform,
                                            sort: 'string');
                                      }))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),

          // 플랫폼 선택 탭 바
          Obx(() {
            if (!isSearching.value) {
              return const SizedBox.shrink();
            }
            if (isSearching.value && autocompletes.isNotEmpty) {
              return const SizedBox.shrink();
            } else if (searchResultController.searchResults.isNotEmpty ||
                isSearching.value) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: platforms.map((platform) {
                        return TabButton(
                          title: platform,
                          isSelected: selectedPlatform == platform,
                          onTap: () {
                            setState(() {
                              selectedPlatform = platform;
                            });
                            searchResultController
                                .clearResults(); // 기존 검색 결과 초기화
                            searchResultController.searchItems(
                                textController.text,
                                selectedPlatform); // 새 검색 실행
                          },
                          selectedColor: AppColors.darkgrey,
                          unselectedColor: AppColors.white,
                          selectedTextColor: AppColors.white,
                          unselectedTextColor: AppColors.darkgrey,
                          selectedBorderColor: AppColors.darkgrey,
                        );
                      }).toList(),
                    ),
                    const Divider(
                      color: AppColors.lightgrey,
                      height: 24,
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          // 검색 결과
          Obx(() {
            // 자동완성 중
            if (autocompletes.isNotEmpty) {
              return const SizedBox.shrink();
            }

            // 로딩 중
            if (searchResultController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            // 검색 결과 없을 경우
            if (searchResultController.searchResults.isEmpty &&
                isSearching.value) {
              return const Center(child: Text("검색 결과가 없습니다"));
            }

            return Expanded(
              child: GridView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                itemCount: searchResultController.searchResults.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.55,
                ),
                itemBuilder: (context, index) {
                  final item = searchResultController.searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => ItemDetailScreen(
                          itemId: item.itemId, platform: item.platform));
                    },
                    child:
                        ItemPreview(isHome: false, size: 'medium', item: item),
                  );
                },
              ),
            );
          }),

          if (searchResultController.isLoading.value &&
              searchResultController.searchResults.isNotEmpty)
            const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 50)
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
