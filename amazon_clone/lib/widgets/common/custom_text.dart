import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String data;

  const CustomText(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
    );
  }
}
