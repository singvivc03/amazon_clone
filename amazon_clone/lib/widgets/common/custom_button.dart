import 'package:amazon_clone/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomButton(this.text, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50)),
        child: CustomText(text));
  }
}
