import 'package:flutter/material.dart';
import 'package:odd/modules/common/default_layout.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(child: Text('마이페이지'));
  }
}
