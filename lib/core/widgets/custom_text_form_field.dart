import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/custom_text_field_bloc/custom_text_field_bloc.dart';

import 'package:tourist_guide/core/colors/colors.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String fieldType;
  final TextEditingController? passwordController;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    required this.fieldType,
    this.passwordController,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late FormFieldBloc _bloc;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _bloc = FormFieldBloc(); // Updated type

    if (widget.fieldType == 'confirmPassword' &&
        widget.passwordController != null) {
      widget.passwordController!.addListener(_onPasswordChange);
      widget.controller.addListener(_onConfirmPasswordChange);
    }
  }

  @override
  void dispose() {
    if (widget.fieldType == 'confirmPassword' &&
        widget.passwordController != null) {
      widget.passwordController!.removeListener(_onPasswordChange);
      widget.controller.removeListener(_onConfirmPasswordChange);
    }
    _bloc.close();
    super.dispose();
  }

  void _onPasswordChange() {
    if (widget.fieldType == 'confirmPassword') {
      _bloc.add(UpdatePasswordEvent(widget.passwordController!.text));
      _bloc.add(TextChangedEvent(
        text: widget.controller.text,
        fieldType: widget.fieldType,
      ));
    }
  }

  void _onConfirmPasswordChange() {
    if (widget.fieldType == 'confirmPassword') {
      _bloc.add(TextChangedEvent(
        text: widget.controller.text,
        fieldType: widget.fieldType,
      ));
    }
  }

  bool isFieldValid() {
    if (widget.fieldType == 'confirmPassword') {
      return isValid &&
          widget.controller.text == widget.passwordController?.text;
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<FormFieldBloc, CustomFormFieldState>(
        // Updated types
        listener: (context, state) {
          if (state is FormFieldValidationState) {
            // Updated type
            setState(() {
              isValid = state.isValid;
            });
          }
        },
        builder: (context, state) {
          final obscureText = state is FormFieldValidationState // Updated type
              ? state.obscureText
              : widget.isPassword;

          final passwordRequirements =
              state is FormFieldValidationState // Updated type
                  ? state.passwordRequirements
                  : null;

          final bool showRequirements = widget.fieldType == 'password' &&
              passwordRequirements != null &&
              !passwordRequirements.values.every((met) => met);

          final bool showError = state is FormFieldValidationState &&
              state.showError &&
              state.errorMessage != null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                cursorColor: isDarkMode ? kMainColorDark : kMainColor,
                controller: widget.controller,
                obscureText: widget.isPassword ? obscureText : false,
                keyboardType: widget.keyboardType,
                onChanged: (value) {
                  _bloc.add(TextChangedEvent(
                      text: value, fieldType: widget.fieldType));
                },
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  prefixIcon: Icon(widget.prefixIcon),
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: isDarkMode ? kMainColorDark : kMainColor,
                          ),
                          onPressed: () {
                            _bloc.add(TogglePasswordVisibilityEvent());
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: BorderSide(
                      color: showError ? Colors.redAccent : Colors.grey,
                      width: 1.5.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: BorderSide(
                      color:
                          showError ? Colors.redAccent : Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: BorderSide(
                      color: showError
                          ? Colors.redAccent 
                          : isDarkMode
                              ? kMainColorDark 
                              : kMainColor, 
                      width: 2.0.w,
                    ),
                  ),
                ),
                style:
                    TextStyle(color: isDarkMode ? kMainColorDark : kMainColor),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showError)
                      Padding(
                        padding: REdgeInsets.only(top: 8.h, left: 16.w),
                        child: Text(
                          state is FormFieldValidationState
                              ? state.errorMessage ?? ''
                              : '',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    if (showRequirements)
                      Padding(
                        padding: REdgeInsets.only(top: 8.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: passwordRequirements?.entries.map((entry) {
                                return Padding(
                                  padding: REdgeInsets.symmetric(vertical: 2.h),
                                  child: Row(
                                    children: [
                                      Icon(
                                        entry.value
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: entry.value
                                            ? Colors.green
                                            : Colors.grey,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        entry.key,
                                        style: TextStyle(
                                          color: entry.value
                                              ? Colors.green
                                              : Colors.grey,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList() ??
                              [],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
