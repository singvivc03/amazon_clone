import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;

  const CustomTextField(this.textEditingController, this.hintText, {super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black38,
            ),
          )),
      validator: (val) {},
    );
  }
}
