import 'package:flutter/material.dart';
import '../../constants/appcolors.dart';

class HomeLayout extends StatelessWidget {
  final Widget child;

  const HomeLayout({
    required this.child,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }
}