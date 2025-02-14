import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/bloc/auth_text_field_bloc/auth_text_field_bloc.dart';
import 'package:tourist_guide/bloc/auth_text_field_bloc/auth_text_field_event.dart';
import 'package:tourist_guide/bloc/auth_text_field_bloc/auth_text_field_states.dart';

class AuthTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String fieldType;
  final TextEditingController? passwordController;

  const AuthTextField({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.fieldType,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.passwordController,
  }) : super(key: key);

  @override
  State<AuthTextField> createState() => AuthTextFieldState();
}

class AuthTextFieldState extends State<AuthTextField> {
  late AuthTextFieldBloc _bloc;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _bloc = AuthTextFieldBloc();

    if (widget.fieldType == 'confirmPassword' && widget.passwordController != null) {
      widget.passwordController!.addListener(_onPasswordChange);
      widget.controller.addListener(_onConfirmPasswordChange);
    }
  }

  @override
  void dispose() {
    if (widget.fieldType == 'confirmPassword' && widget.passwordController != null) {
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
      return isValid && widget.controller.text == widget.passwordController?.text;
    }
    return isValid;
  }

  Widget _buildRequirementItem(String requirement, bool isMet) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      margin: REdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              isMet ? Icons.check_circle : Icons.circle_outlined,
              key: ValueKey<bool>(isMet),
              color: isMet ? Colors.green : Colors.grey,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                color: isMet ? Colors.green : Colors.grey,
                fontSize: 12.sp,
              ),
              child: Text(requirement),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<AuthTextFieldBloc, AuthTextFState>(
        listenWhen: (previous, current) => previous.isValid != current.isValid,
        listener: (context, state) {
          setState(() {
            isValid = state.isValid;
          });
        },
        buildWhen: (previous, current) {
          return previous.obscureText != current.obscureText ||
              previous.showError != current.showError ||
              previous.errorMessage != current.errorMessage ||
              previous.passwordRequirements != current.passwordRequirements ||
              (previous.passwordRequirements != null &&
                  current.passwordRequirements != null &&
                  !mapEquals(previous.passwordRequirements, current.passwordRequirements));
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                cursorColor: isDarkMode ? kMainColorDark : kMainColor,
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                obscureText: widget.isPassword && state.obscureText,
                onChanged: (value) {
                  _bloc.add(TextChangedEvent(
                    text: value,
                    fieldType: widget.fieldType,
                  ));
                },
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  hintText: widget.hintText,
                  errorText: state.showError ? state.errorMessage : null,
                  prefixIcon: Icon(
                    widget.prefixIcon,
                    color: isDarkMode ? kMainColorDark : kMainColor,
                  ),
                  suffixIcon: widget.isPassword
                      ? IconButton(
                    icon: Icon(
                      state.obscureText
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: isDarkMode ? kMainColorDark : kMainColor,
                    ),
                    onPressed: () {
                      _bloc.add(const TogglePasswordVisibilityEvent());
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: BorderSide(
                      color: state.showError ? Colors.redAccent : Colors.grey,
                      width: 1.5.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: BorderSide(
                      color: state.showError
                          ? Colors.redAccent
                          : Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: BorderSide(
                      color: state.showError
                          ? Colors.redAccent
                          : isDarkMode
                          ? kMainColorDark
                          : kMainColor,
                      width: 2.0.w,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0.r),
                    borderSide: const BorderSide(
                      color: Colors.redAccent,
                      width: 2.0,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: isDarkMode ? kMainColorDark : kMainColor,
                ),
              ),
              if (widget.fieldType == 'password' &&
                  state.passwordRequirements != null &&
                  widget.controller.text.isNotEmpty&&
                  !state.passwordRequirements!.values.every((met) => met))
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Padding(
                    padding: REdgeInsets.only(top: 8.0.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var entry in state.passwordRequirements!.entries)
                          _buildRequirementItem(
                            entry.key,
                            entry.value,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}