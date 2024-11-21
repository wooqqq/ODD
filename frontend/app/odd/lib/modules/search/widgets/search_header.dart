import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:odd/constants/appcolors.dart';
import 'package:odd/modules/common/cart_button.dart';

class SearchHeader extends StatelessWidget {
  final TextEditingController textController;
  final Function(String) onTextChanged;
  final Function(String) onSubmitted;
  final VoidCallback onClearPressed; // 닫기 버튼
  final bool isSearching;

  const SearchHeader({
    super.key,
    required this.textController,
    required this.onTextChanged,
    required this.onSubmitted,
    required this.onClearPressed,
    required this.isSearching, // 검색 상태 초기화
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Image.asset(
              'assets/icons/navbar/search_default.png',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.only(left: 14, bottom: 5),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightgrey),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: '검색어를 입력하세요',
                  border: InputBorder.none,
                  suffixIcon: isSearching // 검색 중일 때만 X 버튼 표시
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            textController.clear();
                            onClearPressed(); // 검색어 및 결과 초기화
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  onTextChanged(value);
                },
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    onSubmitted(value); // 검색 실행
                  }
                },
              ),
            ),
          ),
          CartButton(),
        ],
      ),
    );
  }
}
