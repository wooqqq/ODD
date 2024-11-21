import 'package:flutter/material.dart';
import '../../constants/appcolors.dart';

class DropBox extends StatefulWidget {
  final List<String> filterList;
  final Function(String) onChanged; // 선택된 필터를 전달하는 콜백 함수 추가

  const DropBox({
    super.key,
    required this.filterList,
    required this.onChanged, // 필수 파라미터로 추가
  });

  @override
  _DropBoxState createState() => _DropBoxState();
}

class _DropBoxState extends State<DropBox> {
  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    // initState 내부에서 selectedFilter 초기화
    selectedFilter = widget.filterList[0];
  }

  // 필터링 모달
  void _showFilterModal() {
    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 타이틀
              const Text(
                '정렬 기준',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // 필터 리스트
              ...widget.filterList.map((filter) {
                return ListTile(
                  title: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 20,
                      color: filter == selectedFilter
                          ? AppColors.accent
                          : AppColors.grey,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                    widget.onChanged(filter); // 선택된 값을 콜백 함수로 전달
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showFilterModal,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedFilter,
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/icons/down_icon.png',
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
