import 'package:amazon_clone/widgets/common/custom_button.dart';
import 'package:amazon_clone/widgets/common/custom_textfield.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          CustomTextField(_nameController, "Name"),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(_emailController, "Email"),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(_passwordController, "Password"),
          const SizedBox(
            height: 10,
          ),
          CustomButton("Sign up", () {})
        ],
      ),
    );
  }
}
