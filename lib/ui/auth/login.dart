import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/login_bloc/login_bloc.dart';
import 'package:tourist_guide/bloc/login_bloc/login_event.dart';
import 'package:tourist_guide/bloc/login_bloc/login_state.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 36.h),
                  Text(
                    'Welcome Back! 😍',
                    style: TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Enter your email and password to log in.',
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp),
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
                  _buildLoginButton(),
                  SizedBox(height: 36.h),
                  _buildSignUpRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginLoadingState) {
          CustomSnackBar.showInfo(
            context: context,
            message: state.loadingMessage,
            duration: const Duration(milliseconds: 1000),
          );
        } else if (state is LoginErrorState) {
          CustomSnackBar.showError(
            context: context,
            message: state.errorMessage,
          );
        } else if (state is LoginSuccessState) {
          CustomSnackBar.showSuccess(
            context: context,
            message: state.successMessage,
          );
          Navigator.pushNamed(context, '/home');
        }
      },
      builder: (context, state) {
        return CustomButton(
          text: 'Log In',
          isLoading: state is LoginLoadingState,
          onPressed: state is LoginLoadingState
              ? null
              : () {
            if (_formKey.currentState!.validate()) {
              context.read<LoginBloc>().add(
                LoginUserEvent(
                  email: _emailController.text.trim(),
                  password: _passwordController.text,
                ),
              );
            } else {
              CustomSnackBar.showError(
                context: context,
                message: 'Please fill all required fields correctly',
              );
            }
          },
          height: 56.h,
          width: 0.9.sw,
        );
      },
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(fontSize: 14.sp),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/signup'),
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
    );
  }
}