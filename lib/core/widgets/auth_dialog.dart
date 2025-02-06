import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tourist_guide/core/colors/colors.dart';


class AuthenticationLoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: REdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? kMainColorDark : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDarkMode ? Colors.white : kMainColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Authenticating...',
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// You can also add this method for custom error handling
// void _handleAuthenticationError(String message) {
//   CustomSnackBar.showCustom(
//     context: context,
//     message: message,
//     backgroundColor: Colors.red.shade700,
//     icon: Icons.error_outline,
//     duration: const Duration(seconds: 3),
//   );
// }
