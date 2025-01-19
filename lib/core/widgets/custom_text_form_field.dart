// custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:country_picker/country_picker.dart';
import 'package:tourist_guide/core/colors/colors.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isPassword;
  final TextEditingController? passwordController;
  final String fieldType;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.isPassword = false,
    this.passwordController,
    required this.fieldType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  Country? _selectedCountry;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  final Map<String, bool> _passwordRequirements = {
    'Length': false,
    'Uppercase': false,
    'Lowercase': false,
    'Number': false,
    'Special': false,
  };

  @override
  void initState() {
    super.initState();
    _selectedCountry = CountryParser.parseCountryCode('EG');
    if (widget.fieldType == 'password') {
      _updatePasswordRequirements(widget.controller.text);
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updatePasswordRequirements(String value) {
    setState(() {
      _passwordRequirements['Length'] = value.length >= 8;
      _passwordRequirements['Uppercase'] = value.contains(RegExp(r'[A-Z]'));
      _passwordRequirements['Lowercase'] = value.contains(RegExp(r'[a-z]'));
      _passwordRequirements['Number'] = value.contains(RegExp(r'[0-9]'));
      _passwordRequirements['Special'] =
          value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

      bool allRequirementsMet =
          _passwordRequirements.values.every((met) => met);

      if (allRequirementsMet && _overlayEntry != null) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _removeOverlay();
        });
      }
    });
  }

  Widget _buildRequirement(String text, bool isMet) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isMet ? 0.7 : 1.0,
      child: Padding(
        padding: REdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isMet ? Icons.check_circle : Icons.circle_outlined,
                size: 16.w,
                color: isMet ? kMainColor : Colors.grey,
                key: ValueKey(isMet),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isMet ? kMainColor : Colors.grey,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 250.w,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, 60.h),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: REdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Password must contain:',
                    style: TextStyle(
                      color: kMainColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildRequirement('At least 8 characters',
                      _passwordRequirements['Length']!),
                  _buildRequirement('At least one uppercase letter',
                      _passwordRequirements['Uppercase']!),
                  _buildRequirement('At least one lowercase letter',
                      _passwordRequirements['Lowercase']!),
                  _buildRequirement(
                      'At least one number', _passwordRequirements['Number']!),
                  _buildRequirement('At least one special character',
                      _passwordRequirements['Special']!),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      searchAutofocus: true,
      showSearch: true,
      useRootNavigator: true,
      favorite: ['EG', 'SA', 'AE', 'US', 'GB'],
      countryListTheme: CountryListThemeData(
        flagSize: 25.w,
        backgroundColor: Colors.white,
        textStyle: TextStyle(fontSize: 14.sp, color: Colors.black),
        bottomSheetHeight: 0.7.sh,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        searchTextStyle: TextStyle(
          color: kMainColor,
          fontSize: 14.sp,
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search',
          labelStyle: TextStyle(
            color: kMainColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
          hintText: 'Start typing to search',
          hintStyle: TextStyle(
            color: kMainColor.withOpacity(0.5),
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(Icons.search, color: kMainColor, size: 20.w),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: kMainColor.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(20.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kMainColor.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(20.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kMainColor),
            borderRadius: BorderRadius.circular(20.r),
          ),
          contentPadding: REdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          widget.controller.clear();
        });
      },
    );
  }

  String? _validateField(String? value) {
    switch (widget.fieldType) {
      case 'phone':
        if (value == null || value.isEmpty) {
          return null;
        }

        String cleanNumber = value
            .replaceAll('+${_selectedCountry?.phoneCode}', '')
            .replaceAll(RegExp(r'[\s\-$$$$]'), '')
            .trim();

        if (cleanNumber.startsWith('0')) {
          cleanNumber = cleanNumber.substring(1);
        }

        switch (_selectedCountry?.countryCode) {
          case 'EG':
            if (!RegExp(r'^1[0125][0-9]{8}$').hasMatch(cleanNumber)) {
              return 'Please enter a valid Egyptian phone number';
            }
            break;
          default:
            if (cleanNumber.length < 7 || cleanNumber.length > 15) {
              return 'Please enter a valid phone number';
            }
        }
        return null;

      case 'name':
        if (value == null || value.isEmpty) {
          return 'Please enter your full name';
        }
        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
          return 'Name should only contain letters';
        }
        if (value.length < 3) {
          return 'Name should be at least 3 characters';
        }
        if (!value[0].toUpperCase().contains(value[0])) {
          return 'First letter must be capitalized';
        }
        return null;

      case 'email':
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;

      case 'password':
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        bool isValid =
            _passwordRequirements.values.every((requirement) => requirement);
        if (!isValid) {
          return 'Please meet all password requirements';
        }
        return null;

      case 'confirmPassword':
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != widget.passwordController?.text) {
          return 'Passwords do not match';
        }
        return null;

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (widget.fieldType == 'password') {
            setState(() {
              if (hasFocus) {
                _createOverlay();
              } else {
                _removeOverlay();
              }
            });
          }
        },
        child: TextFormField(
          cursorColor: kMainColor,
          controller: widget.controller,
          style: TextStyle(fontSize: 17.sp),
          onChanged: (value) {
            if (widget.fieldType == 'password') {
              _updatePasswordRequirements(value);
              if (_overlayEntry != null) {
                _overlayEntry!.markNeedsBuild();
              }
            }
          },
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.fieldType == 'phone'
                ? 'Enter phone number'
                : widget.hintText,
            labelStyle: TextStyle(
              color: kMainColor,
              fontSize: 16.sp,
            ),
            prefixIcon: widget.fieldType == 'phone'
                ? GestureDetector(
                    onTap: _showCountryPicker,
                    child: Container(
                      padding: REdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedCountry?.flagEmoji ?? '🌍',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '+${_selectedCountry?.phoneCode ?? ''}',
                            style: TextStyle(
                              color: kMainColor,
                              fontSize: 16.sp,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down,
                              color: kMainColor, size: 25.w),
                        ],
                      ),
                    ),
                  )
                : Icon(widget.prefixIcon, color: kMainColor, size: 24.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.r),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.r),
              borderSide: BorderSide(color: kMainColor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.r),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: REdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 16.h,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: kMainColor,
                      size: 24.w,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
          keyboardType: widget.fieldType == 'phone'
              ? TextInputType.phone
              : widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.isPassword ? _obscureText : false,
          validator: _validateField,
          inputFormatters: widget.fieldType == 'phone'
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                  PhoneNumberFormatter(),
                ]
              : null,
        ),
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String cleaned = newValue.text.replaceAll(RegExp(r'[\s\-$$$$]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }

    if (cleaned.length > 10) {
      cleaned = cleaned.substring(0, 10);
    }

    String formatted = '';
    for (int i = 0; i < cleaned.length; i++) {
      if (i == 3 || i == 6) {
        formatted += ' ';
      }
      formatted += cleaned[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
