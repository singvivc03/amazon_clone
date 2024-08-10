import 'package:amazon_clone/features/auth/enums/auth_enum.dart';
import 'package:amazon_clone/features/auth/widgets/signin_form.dart';
import 'package:amazon_clone/features/auth/widgets/signup_form.dart';
import 'package:amazon_clone/utils/global_variables.dart';
import 'package:amazon_clone/widgets/common/custom_text.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalVariables.greyBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText("Welcome"),
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  tileColor: _auth == Auth.signUp
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundColor,
                  title: const CustomText("Create account"),
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signUp,
                    groupValue: _auth,
                    onChanged: (Auth? val) => setState(() {
                      _auth = val!;
                    }),
                  ),
                ),
                if (_auth == Auth.signUp)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: GlobalVariables.backgroundColor,
                    child: const SignUpForm(),
                  ),
                ListTile(
                  tileColor: _auth == Auth.signIn
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundColor,
                  title: const CustomText("Sign-in."),
                  leading: Radio(
                    activeColor: GlobalVariables.secondaryColor,
                    value: Auth.signIn,
                    groupValue: _auth,
                    onChanged: (Auth? val) => setState(() {
                      _auth = val!;
                    }),
                  ),
                ),
                if (_auth == Auth.signIn)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: GlobalVariables.backgroundColor,
                    child: const SignInForm(),
                  ),
              ],
            ),
          ),
        ));
  }
}
