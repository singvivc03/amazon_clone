import 'package:flutter/material.dart';

import '../../../widgets/common/custom_button.dart';
import '../../../widgets/common/custom_textfield.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _signInFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: Column(
        children: [
          CustomTextField(_emailController, "Email"),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(_passwordController, "Password"),
          const SizedBox(
            height: 10,
          ),
          CustomButton("Sign in", () {})
        ],
      ),
    );
  }
}
