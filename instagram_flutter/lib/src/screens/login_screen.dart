import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/src/resources/auth_methods.dart';
import 'package:instagram_flutter/src/resources/util.dart';
import 'package:instagram_flutter/src/screens/signup_screen.dart';
import 'package:instagram_flutter/src/widgets/text_field_input.dart';
import 'package:instagram_flutter/utils/colors.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthMethods _authMethods = AuthMethods();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loadSignupScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SignUpScreen(),),);
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await _authMethods.loginUser(email: _emailController.text, password: _passwordController.text);
    setState(() {
      _isLoading = false;
    });
    if (!context.mounted) return;
    if (res != 'Success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout()),
      ),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2,child: Container(),),
              SvgPicture.asset('assets/ic_instagram.svg', color: primaryColor, height: 64,),
              const SizedBox(height: 64,),
              TextFieldInput(textEditingController: _emailController, hintText: "Enter your email", textInputType: TextInputType.text),
              const SizedBox(height: 24,),
              TextFieldInput(textEditingController: _passwordController, hintText: "Enter your password", textInputType: TextInputType.text, obscureText: true,),
              const SizedBox(height: 24,),
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: blueColor,
                  ),
                  child: _isLoading ? const   Center(child: CircularProgressIndicator(),) : const Text("Log in"),
                ),
              ),
              const SizedBox(height: 12,),
              Flexible(flex: 2,child: Container(),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: loadSignupScreen,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Sign up.", style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
    ),);
  }
}
