import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/bloc/custom_text_field_bloc/custom_text_field_bloc.dart';
import 'package:tourist_guide/bloc/custom_text_field_bloc/custom_text_field_event.dart';
import 'package:tourist_guide/bloc/custom_text_field_bloc/custom_text_field_state.dart';
import 'package:tourist_guide/core/colors/colors.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String fieldType;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    required this.fieldType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomTextFieldBloc(),
      child: BlocBuilder<CustomTextFieldBloc, CustomTextFieldState>(
        builder: (context, state) {
          final bloc = context.read<CustomTextFieldBloc>();
          final obscureText = state is TextFieldValidationState
              ? state.obscureText
              : isPassword;

          final passwordRequirements = state is TextFieldValidationState
              ? state.passwordRequirements
              : null;

          final bool showRequirements = fieldType == 'password' &&
              passwordRequirements != null &&
              !passwordRequirements.values.every((met) => met);

          final bool showError = state is TextFieldValidationState &&
              state.showError &&
              state.errorMessage != null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                cursorColor: kMainColor,
                controller: controller,
                obscureText: isPassword ? obscureText : false,
                keyboardType: keyboardType,
                validator: (value) {
                  bloc.add(TextChangedEvent(
                      text: value ?? '', fieldType: fieldType));
                  return null;
                },
                onChanged: (value) {
                  bloc.add(TextChangedEvent(text: value, fieldType: fieldType));
                },
                decoration: InputDecoration(
                  labelText: labelText,
                  hintText: hintText,
                  labelStyle: TextStyle(color: kMainColor),
                  hintStyle:
                      TextStyle(color: kMainColor.withValues(alpha: 150)),
                  prefixIcon: Icon(prefixIcon, color: kMainColor),
                  suffixIcon: isPassword
                      ? IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: kMainColor,
                          ),
                          onPressed: () {
                            bloc.add(TogglePasswordVisibilityEvent());
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: BorderSide(
                        color: showError ? Colors.redAccent : Colors.grey,
                        width: 1.5.w),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: BorderSide(
                        color: showError
                            ? Colors.redAccent
                            : Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: BorderSide(
                        color: showError ? Colors.redAccent : kMainColor,
                        width: 2.0.w),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(color: kMainColor),
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
                          state is TextFieldValidationState
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
