import 'package:flutter/material.dart';
import 'package:odd/constants/appcolors.dart';

class UserDropBox extends StatefulWidget {
  final List<String> filterList;
  final String selectedFilter;
  final Function(String) onChanged;

  const UserDropBox({
    super.key,
    required this.filterList,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  _UserDropBoxState createState() => _UserDropBoxState();
}

class _UserDropBoxState extends State<UserDropBox> {
  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.selectedFilter;
  }

  @override
  void didUpdateWidget(covariant UserDropBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 부모의 selectedFilter가 변경되면 UserDropBox의 selectedFilter도 업데이트
    if (widget.selectedFilter != selectedFilter) {
      setState(() {
        selectedFilter = widget.selectedFilter;
      });
    }
  }

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
              const Text(
                '정렬 기준',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
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
                    widget.onChanged(filter);
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
