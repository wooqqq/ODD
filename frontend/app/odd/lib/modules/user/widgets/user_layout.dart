import 'package:flutter/material.dart';
import 'package:odd/constants/appcolors.dart';

class UserLayout extends StatelessWidget {
  final Widget child;

  const UserLayout({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: child,
        ),
      ),
    );
  }
}
