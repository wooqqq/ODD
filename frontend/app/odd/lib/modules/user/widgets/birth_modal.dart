import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:odd/constants/appcolors.dart';

class BirthModal extends StatefulWidget {
  final Function(String) onDateSelected; // 선택된 날짜 전달 함수

  const BirthModal({super.key, required this.onDateSelected});

  @override
  _BirthModalState createState() => _BirthModalState();
}

class _BirthModalState extends State<BirthModal> {
  DateTime _selectedDate = DateTime.now();

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
              children: <Widget>[
                const Text(
                  '생일 등록',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LogoFont',
                    color: AppColors.gsPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                // 달력
                Theme(
                  data: ThemeData(
                    colorScheme: const ColorScheme.light(
                      primary: AppColors.gsPrimary,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    onDateChanged: (DateTime newDate) {
                      setState(() {
                        _selectedDate = newDate;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // 등록 버튼
                ElevatedButton(
                  onPressed: () {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(_selectedDate);
                    widget.onDateSelected(formattedDate);
                    Navigator.of(context).pop(); // 모달 닫기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gsPrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    '${_selectedDate.year}년 ${_selectedDate.month}월 ${_selectedDate.day}일 선택',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 닫기 버튼
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
