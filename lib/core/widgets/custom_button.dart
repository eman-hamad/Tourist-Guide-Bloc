// widgets/custom_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Default responsive values optimized for 390x844
    final defaultWidth = 351.w; // 90% of 390
    final defaultHeight = 50.h; // Standard height for 844
    final defaultFontSize = 16.sp; // Standard font size
    final defaultBorderRadius = 25.r; // Rounded corners

    // Use provided values or defaults
    final buttonWidth = width ?? defaultWidth;
    final buttonHeight = height ?? defaultHeight;
    final buttonFontSize = fontSize ?? defaultFontSize;
    final buttonBorderRadius = borderRadius ?? defaultBorderRadius;

    return SizedBox(
      width: buttonWidth.clamp(117.w, 351.w), // 30% to 90% of 390
      height: buttonHeight.clamp(42.h, 67.h), // 5% to 8% of 844
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kMainColor,
          padding: REdgeInsets.symmetric(
            vertical: 10.h, // Vertical padding
            horizontal: 15.w, // Horizontal padding
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: buttonFontSize.clamp(14.sp, 18.sp),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
