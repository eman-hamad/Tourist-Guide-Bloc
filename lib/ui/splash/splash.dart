import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/ui/auth/login.dart';

import '../../core/widgets/custom_page_route.dart';
import '../home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoggedIn = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() async {
    // First, start a fade-out animation for current content
    setState(() {
      _controller.reverse();
    });

    // Wait for the animation to complete
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    // Navigate to the appropriate screen with custom animation
    Navigator.of(context).pushReplacement(
      CustomPageRoute(
        child: isLoggedIn ? const HomeScreen() : const Login(),
        type: PageTransitionType.slideUp, // or any other type
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie Animation
                Lottie.asset(
                  'assets/images/splash_animation.json',
                  controller: _controller,
                  height: 300.h,
                  animate: true,
                  onLoaded: (composition) {
                    _controller
                      ..duration = composition.duration
                      ..forward();
                  },
                ),
                SizedBox(height: 40.h),
                // Welcome Text with Animation
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20.h * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'Welcome to Tourist Guide',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Discover amazing places and create unforgettable memories',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                // Button
                if (!isLoading)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 3),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 50.h * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: ElevatedButton(
                      onPressed: _navigateToNextScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50.w,
                          vertical: 15.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        isLoggedIn ? 'Continue to Home' : 'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (isLoading)
                  SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
