import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/colors/colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../core/widgets/custom_text_form_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkStoredData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: REdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 24.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 36.h),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Welcome Back! 😍',
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Happy to see you again! Please enter your email and password to login to your account.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 36.h),
                  CustomTextField(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icons.email,
                    controller: _emailController,
                    fieldType: 'email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 24.h),
                  CustomTextField(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icons.lock,
                    controller: _passwordController,
                    fieldType: 'password',
                    isPassword: true,
                  ),
                  SizedBox(height: 48.h),
                  CustomButton(
                    text: 'Log In',
                    fontSize: 16.sp,
                    onPressed: _login,
                    height: 56.h,
                    width: 0.9.sw,
                  ),
                  SizedBox(height: 36.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          '  Sign Up',
                          style: TextStyle(
                            color: kMainColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show loading indicator
        CustomSnackBar.showInfo(
          context: context,
          message: 'Logging in...',
          duration: const Duration(milliseconds: 1000),
        );

        // Add a small delay to show the loading message
        await Future.delayed(const Duration(milliseconds: 500));

        final prefs = await SharedPreferences.getInstance();
        final usersString = prefs.getString('users_list');

        if (usersString == null) {
          CustomSnackBar.showWarning(
            context: context,
            message: 'No registered users found. Please sign up first.',
            duration: const Duration(seconds: 3),
          );
          return;
        }

        List<Map<String, dynamic>> usersList = List<Map<String, dynamic>>.from(
          json.decode(usersString),
        );

        final user = usersList.firstWhere(
          (user) =>
              user['email'].toString().toLowerCase() ==
                  _emailController.text.toLowerCase() &&
              user['password'] == _passwordController.text,
          orElse: () => {},
        );

        if (user.isEmpty) {
          CustomSnackBar.showError(
            context: context,
            message: 'Invalid email or password. Please try again.',
            duration: const Duration(seconds: 3),
          );
          return;
        }

        // Save the login status
        await prefs.setString('current_user', json.encode(user));
        await prefs.setBool('isLoggedIn', true);

        if (!mounted) return;

        // Show personalized success message
        CustomSnackBar.showCustom(
          context: context,
          message: 'Welcome back, ${user['name']}! 👋',
          backgroundColor: kMainColor,
          icon: Icons.celebration,
          duration: const Duration(seconds: 2),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        );

        // Delay before navigating to HomePage
        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;

        // Navigate to HomePage
        Navigator.pushNamed(context, '/home');
      } catch (e) {
        CustomSnackBar.showCustom(
          context: context,
          message: 'Oops! Something went wrong',
          backgroundColor: Colors.red,
          icon: Icons.error_outline,
          duration: const Duration(seconds: 3),
        );

        // Log the error for debugging
        debugPrint('Login error: $e');
      }
    } else {
      CustomSnackBar.showWarning(
        context: context,
        message: 'Please check your input and try again',
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('current_user');

    if (!context.mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> checkStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Redirect to HomePage if the user is already logged in
    // if (isLoggedIn) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => const HomePage()),
    //   );
    // }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserString = prefs.getString('currentUser');
    if (currentUserString != null) {
      return json.decode(currentUserString);
    }
    return null;
  }
}
