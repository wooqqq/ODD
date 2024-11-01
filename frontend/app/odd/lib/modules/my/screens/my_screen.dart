import 'package:flutter/material.dart';
import 'package:odd/modules/common/default_layout.dart';

class MyScreen extends StatelessWidget {
  MyScreen({
    Key? key
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(child:
      Text('my screen')
    );
  }
}