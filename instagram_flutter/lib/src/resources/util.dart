import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(final ImageSource imageSource) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: imageSource);

  if (file != null) {
    return await file.readAsBytes();
  }
}

showSnackBar(String content, BuildContext buildContext) {
  print("I am here");
  ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(content: Text(content),),);
}