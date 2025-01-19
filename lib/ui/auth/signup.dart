import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/core/colors/colors.dart';

import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../core/widgets/custom_text_form_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _Signup();
}

class _Signup extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
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
                      'Sign up !',
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Welcome! Please enter your Name, email and password to create your account.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 36.h),
                  CustomTextField(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person,
                    controller: _nameController,
                    fieldType: 'name',
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 24.h),
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
                  SizedBox(height: 24.h),
                  CustomTextField(
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    prefixIcon: Icons.lock_outline,
                    controller: _confirmPasswordController,
                    fieldType: 'confirmPassword',
                    isPassword: true,
                    passwordController: _passwordController,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 24.h),
                  CustomTextField(
                    labelText: 'Phone Number (optional)',
                    hintText: 'Enter your phone number',
                    prefixIcon: CupertinoIcons.phone,
                    controller: _phoneNumberController,
                    fieldType: 'phone',
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 48.h),
                  CustomButton(
                    text: 'Sign Up',
                    fontSize: 16.sp,
                    onPressed: _submitForm,
                    height: 56.h,
                    width: 0.9.sw,
                  ),
                  SizedBox(height: 36.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          '  Log in',
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final prefs = await SharedPreferences.getInstance();

        // Check for existing users
        List<Map<String, dynamic>> usersList = [];
        String? existingUsersString = prefs.getString('users_list');

        if (existingUsersString != null) {
          // Parse existing users
          usersList =
              List<Map<String, dynamic>>.from(json.decode(existingUsersString));

          // Check for duplicate email
          if (usersList.any((user) =>
              user['email'].toString().toLowerCase() ==
              _emailController.text.toLowerCase())) {
            if (!mounted) return;

            CustomSnackBar.showError(
              context: context,
              message: 'This email is already registered',
            );
            return;
          } else if (_phoneNumberController.text.trim().isNotEmpty &&
              usersList.any((user) =>
                  user['phone']?.toString().toLowerCase() ==
                  _phoneNumberController.text.trim().toLowerCase())) {
            if (!mounted) return;

            CustomSnackBar.showError(
              context: context,
              message: 'This phone number is already registered',
            );
            return;
          }
        }

        // Create new user data
        Map<String, dynamic> newUser = {
          'id': DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
          'name': _nameController.text,
          'email': _emailController.text.toLowerCase(),
          'password': _passwordController.text,
          'phone': _phoneNumberController.text,
          'registrationDate': DateTime.now().toIso8601String(),
        };

        // Add new user to the list
        usersList.add(newUser);

        // Save updated users list
        await prefs.setString('users_list', json.encode(usersList));

        // Save current user for session
        await prefs.setString('current_user', json.encode(newUser));
        await prefs.setBool('isLoggedIn', true);

        debugPrint('Users List: ${prefs.getString('users_list')}');
        debugPrint('Current User: ${prefs.getString('current_user')}');

        if (!mounted) return;

        CustomSnackBar.showSuccess(
          context: context,
          message: 'Registration successful!',
        );

        // Navigate directly to HomePage after successful signup
        Navigator.pushNamed(context, '/login');
      } catch (e) {
        debugPrint('Error during registration: $e');
        CustomSnackBar.showError(
          context: context,
          message: 'Registration failed: ${e.toString()}',
        );
      }
    }
  }
}
