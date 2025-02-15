// lib/presentation/auth/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/features/auth/bloc/auth_bloc.dart';
import 'package:tourist_guide/features/auth/bloc/auth_event.dart';
import 'package:tourist_guide/features/auth/bloc/auth_states.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/auth_text_field.dart';
import 'package:tourist_guide/core/widgets/custom_button.dart';
import 'package:tourist_guide/core/widgets/custom_snack_bar.dart';
import 'package:tourist_guide/core/widgets/loading_overlay.dart';
import '../../../core/di/service_locator.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        authService: ServiceLocator.get(),
        biometricService: ServiceLocator.get(),
      ),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>(); // Single form key
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          CustomSnackBar.showInfo(
            context: context,
            message: state.message,
            duration: const Duration(milliseconds: 1500),
          );
        } else if (state is AuthSuccess) {
          CustomSnackBar.showSuccess(
            context: context,
            message: state.message,
            duration: const Duration(milliseconds: 1500),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthError) {
          CustomSnackBar.showError(
            context: context,
            message: state.message,
            duration: const Duration(milliseconds: 1500),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: Form( // Single Form widget
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 24.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 36.h),
                        Text(
                          'Sign up!',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Create your account to get started.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 36.h),
                        _buildSignUpForm(),
                        SizedBox(height: 48.h),
                        _buildSignUpButton(),
                        SizedBox(height: 36.h),
                        _buildLoginRow(),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is AuthLoading)
                LoadingOverlay(message: state.message),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
        AuthTextField(
          labelText: 'Full Name',
          hintText: 'Enter your full name',
          prefixIcon: Icons.person,
          controller: _nameController,
          fieldType: 'name',
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          labelText: 'Email',
          hintText: 'Enter your email',
          prefixIcon: Icons.email,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          fieldType: 'email',
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          labelText: 'Password',
          hintText: 'Enter your password',
          prefixIcon: Icons.lock,
          controller: _passwordController,
          isPassword: true,
          fieldType: 'password',
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          labelText: 'Confirm Password',
          hintText: 'Confirm your password',
          prefixIcon: Icons.lock_outline,
          controller: _confirmPasswordController,
          isPassword: true,
          fieldType: 'confirmPassword',
          passwordController: _passwordController,
        ),
        SizedBox(height: 24.h),
        AuthTextField(
          fieldType: 'phone',
          labelText: 'Phone Number (Optional)',
          hintText: 'Enter your phone number',
          prefixIcon: Icons.phone,
          controller: _phoneController,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: CustomButton(
        text: 'Sign Up',
        onPressed: _handleSignUp,
      ),
    );
  }

  Widget _buildLoginRow() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(fontSize: 14.sp),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/login'),
          child: Text(
            'Log In',
            style: TextStyle(
              color: isDarkMode ? kMainColorDark : kMainColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        SignUpRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          phone: _phoneController.text.trim(),
        ),
      );
    }
  }
}