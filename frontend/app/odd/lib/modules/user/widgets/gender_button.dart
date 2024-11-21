import 'package:flutter/material.dart';
import 'package:odd/constants/appcolors.dart';

class GenderButton extends StatelessWidget {
  final String selectedGender; // '0' :  선택안됨 'F': 여자, 'M': 남자
  final Function(String) onGenderSelected;

  const GenderButton({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              onGenderSelected("F");
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: selectedGender == "F"
                    ? AppColors.gsPrimary
                    : AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                border: Border.all(color: AppColors.lightgrey),
              ),
              child: Center(
                child: Text(
                  '여자',
                  style: TextStyle(
                    color:
                        selectedGender == "F" ? Colors.white : AppColors.grey,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              onGenderSelected("M");
            },
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: selectedGender == "M"
                    ? AppColors.gsPrimary
                    : AppColors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                border: Border.all(color: AppColors.lightgrey),
              ),
              child: Center(
                child: Text(
                  '남자',
                  style: TextStyle(
                    color:
                        selectedGender == "M" ? Colors.white : AppColors.grey,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
