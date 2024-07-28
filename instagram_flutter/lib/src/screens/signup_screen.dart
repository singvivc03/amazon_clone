import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layout_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/src/resources/auth_methods.dart';
import 'package:instagram_flutter/src/resources/util.dart';
import 'package:instagram_flutter/src/screens/login_screen.dart';
import 'package:instagram_flutter/src/widgets/text_field_input.dart';
import 'package:instagram_flutter/utils/colors.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  void selectImage() async {
      Uint8List uint8list = await pickImage(ImageSource.gallery);
      setState(() {
        _image = uint8list;
      });
  }

  void signupUser() async {
    setState(() {
      _isLoading = true;
    });
    String result = await AuthMethods().signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        userName: _userNameController.text,
        bio: _bioController.text,
        file: _image!
    );
    setState(() {
      _isLoading = false;
    });
    if (!context.mounted) return;
    if (result != 'Success') {
      showSnackBar(result, context);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout()),
      ),);
    }
  }

  void loadLoginScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen(),),);
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

              Stack(
                children: [
                  _image != null ? CircleAvatar(radius: 64, backgroundImage: MemoryImage(_image!), backgroundColor: Colors.red,) :
                  const CircleAvatar(radius: 64, backgroundImage: NetworkImage("https://i.stack.imgur.com/l60Hf.png"),),
                  Positioned(bottom: -10, left: 80, child: IconButton(onPressed: selectImage, icon: const Icon(Icons.add_a_photo)))
                ],
              ),
              const SizedBox(height: 24,),

              TextFieldInput(textEditingController: _userNameController, hintText: "Enter your username", textInputType: TextInputType.text),
              const SizedBox(height: 24,),

              TextFieldInput(textEditingController: _emailController, hintText: "Enter your email", textInputType: TextInputType.text),
              const SizedBox(height: 24,),

              TextFieldInput(textEditingController: _passwordController, hintText: "Enter your password", textInputType: TextInputType.text, obscureText: true,),
              const SizedBox(height: 24,),

              TextFieldInput(textEditingController: _bioController, hintText: "Enter your bio", textInputType: TextInputType.text),
              const SizedBox(height: 24,),

              InkWell(
                onTap: signupUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: blueColor,
                  ),
                  child: _isLoading ? const Center(child: CircularProgressIndicator(),) : const Text("Log in"),
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
                    onTap: loadLoginScreen,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Login.", style: TextStyle(fontWeight: FontWeight.bold),),
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
