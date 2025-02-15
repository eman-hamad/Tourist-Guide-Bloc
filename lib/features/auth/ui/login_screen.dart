// lib/presentation/auth/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/auth_text_field.dart';
import 'package:tourist_guide/core/widgets/custom_button.dart';
import 'package:tourist_guide/core/widgets/custom_snack_bar.dart';
import 'package:tourist_guide/core/widgets/loading_overlay.dart';
import 'package:tourist_guide/features/auth/bloc/auth_bloc.dart';
import 'package:tourist_guide/features/auth/bloc/auth_event.dart';
import 'package:tourist_guide/features/auth/bloc/auth_states.dart';

import '../../../core/di/service_locator.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        authService: ServiceLocator.get(),
        biometricService: ServiceLocator.get(),
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 24.h,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 36.h),
                        Text(
                          'Welcome Back! 😍',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Enter your email and password to log in.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 36.h),
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
                        SizedBox(height: 48.h),
                        _buildLoginButton(),
                        SizedBox(height: 36.h),
                        _buildSignUpRow(),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is AuthLoading) LoadingOverlay(message: state.message),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: CustomButton(
        text: 'Log In',
        onPressed: _handleLogin,
      ),
    );
  }

  Widget _buildSignUpRow() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(fontSize: 14.sp),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/signup'),
          child: Text(
            'Sign Up',
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

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            SignInRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    } else {
      CustomSnackBar.showError(
        context: context,
        message: 'Please fill all required fields correctly',
        duration: const Duration(milliseconds: 1500),
      );
    }
  }
}
