import 'dart:typed_data';

import 'package:only_vocal/components/colors.dart';
import 'package:only_vocal/components/text_field_input.dart';
import 'package:only_vocal/components/utils.dart';
import 'package:only_vocal/main.dart';
import 'package:only_vocal/models/song.dart';
import 'package:only_vocal/resources/auth_methods.dart';
import 'package:only_vocal/screens/home_screen.dart';
import 'package:only_vocal/screens/auth_screens/login.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  // Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }


  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    // Assuming AuthMethods() and necessary user information are defined elsewhere
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _userNameController.text,
      // file: _image!,
    );

    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  // void selectImage() async {
  //   Uint8List im = await pickImage(ImageSource.gallery);

  //   setState(() {
  //     _image = im;
  //   });
  // }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  'Sign Up',
                  style: TextStyle(color: const Color.fromARGB(255, 232, 223, 223), fontSize: 35),
                ),
                const SizedBox(height: 20),

                // Circular avatar for profile image
                // Stack(
                //   children: [
                //     _image != null
                //         ? CircleAvatar(
                //             radius: 64,
                //             backgroundImage: MemoryImage(_image!),
                //           )
                //         : CircleAvatar(
                //             radius: 64,
                //             backgroundImage: NetworkImage(
                //                 'https://i.pinimg.com/originals/65/25/a0/6525a08f1df98a2e3a545fe2ace4be47.jpg'),
                //           ),
                //     Positioned(
                //       bottom: -10,
                //       left: 80,
                //       child: IconButton(
                //         onPressed: selectImage,
                //         icon: const Icon(Icons.add_a_photo),
                //         color: Colors.blue,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 30),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppColors.lightPink),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),
                        const Text(
                          "Username",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TextFieldInput(
                          hintText: 'Enter your Username',
                          textEditingController: _userNameController,
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TextFieldInput(
                          hintText: 'Enter your email',
                          textEditingController: _emailController,
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Password",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TextFieldInput(
                          hintText: 'Enter your password',
                          textEditingController: _passwordController,
                          textInputType: TextInputType.text,
                          isPass: true,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: Colors.blue,
                    ),
                    child: !_isLoading
                        ? const Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white),
                          )
                        : const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Already have an account?',
                        style: TextStyle(color: Color.fromARGB(255, 244, 242, 242)),
                      ),
                    ),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Log in.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
