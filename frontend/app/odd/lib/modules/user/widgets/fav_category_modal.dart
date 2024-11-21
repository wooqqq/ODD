import 'package:flutter/material.dart';
import 'package:odd/constants/appcolors.dart';

class FavCategoryModal extends StatefulWidget {
  final Function(List<String>) onCategoriesSelected;

  const FavCategoryModal({super.key, required this.onCategoriesSelected});

  @override
  _FavCategoryModalState createState() => _FavCategoryModalState();
}

class _FavCategoryModalState extends State<FavCategoryModal> {
  final List<String> categories = [
    '일반식품',
    '주류',
    '과자',
    '과일',
    '유제품',
    '일상용품',
    '빙과류',
    '냉장식품',
    '축산',
    '채소',
    '수산',
    '조리식품',
    '밀키트',
    'freshfood',
    '음료',
    '간편식품',
    '뷰티',
  ];

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Container(
            width: deviceWidth * 0.9,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '선호 카테고리 선택',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LogoFont',
                    color: AppColors.gsPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '필수 3개를 선택해주세요.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // 체크박스 리스트
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: categories.map((category) {
                        final isSelected =
                            selectedCategories.contains(category);
                        return Row(
                          children: [
                            const SizedBox(width: 4),
                            Checkbox(
                              value: isSelected,
                              onChanged: (selected) {
                                setState(() {
                                  if (selected == true) {
                                    if (selectedCategories.length < 3) {
                                      selectedCategories.add(category);
                                    }
                                  } else {
                                    selectedCategories.remove(category);
                                  }
                                });
                              },
                              activeColor: AppColors.gsPrimary,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 9),
                                  if (category == '일반식품')
                                    const Text(
                                      '즉석카레, 통조림, 소스 등',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    )
                                  else if (category == '일상용품')
                                    const Text(
                                      '휴지, 물티슈, 세제 등',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    )
                                  else if (category == '빙과류')
                                    const Text(
                                      '아이스크림',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    )
                                  else if (category == '냉장식품')
                                    const Text(
                                      '소시지, 두부, 유부초밥 등',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    )
                                  else if (category == '조리식품')
                                    const Text(
                                      '즉석조리, 도넛, 떡볶이 등',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    )
                                  else if (category == '밀키트')
                                    const Text(
                                      '심플리쿡, 프레시지, 부대찌개 등',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    )
                                  else if (category == 'freshfood')
                                    const Text(
                                      '삼각김밥, 햄버거, 샌드위치 등',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    )
                                  else if (category == '간편식품')
                                    const Text(
                                      '빵, 요거트, 만두 등',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    )
                                  else if (category == '뷰티')
                                    const Text(
                                      '데오드란트, 핸드크림, 클렌징 등',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 확인 버튼
                SizedBox(
                  width: deviceWidth * 0.6,
                  child: ElevatedButton(
                    onPressed: selectedCategories.length == 3
                        ? () {
                            widget.onCategoriesSelected(selectedCategories);
                            Navigator.of(context).pop(); // 모달 닫기
                          }
                        : null, // 3개 선택되지 않으면 버튼 비활성화
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gsPrimary,
                      disabledBackgroundColor: AppColors.lightgrey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '선택 완료',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 닫기 버튼 (X)
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                size: 30,
                color: AppColors.grey,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // 모달 닫기
              },
            ),
          ),
        ],
      ),
    );
  }
}
