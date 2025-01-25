import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:tourist_guide/bloc/sign_up_bloc/sign_up_bloc.dart';
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
  final _confirmPasswordFieldKey = GlobalKey<CustomTextFieldState>();
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

  bool _validateFields() {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      CustomSnackBar.showError(
        context: context,
        message: 'Please fill all required fields',
      );
      return false;
    }
    return true;
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    key: _confirmPasswordFieldKey,
                    labelText: 'Confirm Password',
                    hintText: 'Confirm your password',
                    prefixIcon: Icons.lock_outline,
                    controller: _confirmPasswordController,
                    fieldType: 'confirmPassword',
                    isPassword: true,
                    passwordController: _passwordController,
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
                  _buildSignUpButton(),
                  SizedBox(height: 36.h),
                  _buildLoginRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return BlocConsumer<SignUpBloc, SignUpStates>(
      listener: (context, state) {
        if (state is SignUpLoadingState) {
          CustomSnackBar.showInfo(
            context: context,
            message: state.loadingMessage,
            duration: const Duration(milliseconds: 1500),
          );
        }
        if (state is SignUpErrorState) {
          CustomSnackBar.showError(
            context: context,
            message: state.errorMessage,
          );
        }
        if (state is SignUpSuccessState) {
          CustomSnackBar.showSuccess(
            context: context,
            message: state.succssesMessage,
          );
          Navigator.pushNamed(context, '/home');
        }
      },
      builder: (context, state) {
        return CustomButton(
          text: 'Sign Up',
          fontSize: 16.sp,
          isLoading: state is SignUpLoadingState,
          onPressed: state is SignUpLoadingState
              ? null
              : () {
            final confirmPasswordState =
                _confirmPasswordFieldKey.currentState;
            final bool isConfirmPasswordValid =
                confirmPasswordState?.isFieldValid() ?? false;

            if (_validateFields()) {
              if (!isConfirmPasswordValid) {
                CustomSnackBar.showError(
                  context: context,
                  message: 'Passwords do not match',
                );
                return;
              }

              SignUpBloc.get(context).add(RegiesterEvent(
                email: _emailController.text.trim(),
                name: _nameController.text.trim(),
                password: _passwordController.text,
                confPassword: _confirmPasswordController.text,
                phone: _phoneNumberController.text.trim(),
              ));
            }
          },
          height: 56.h,
          width: 0.9.sw,
        );
      },
    );
  }

  Widget _buildLoginRow() {
    return Row(
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
          onTap: () => Navigator.pushNamed(context, '/login'),
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
    );
  }
}