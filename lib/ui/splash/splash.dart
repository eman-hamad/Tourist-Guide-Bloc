import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:tourist_guide/bloc/splash_bloc/splash_bloc.dart';
import 'package:tourist_guide/bloc/splash_bloc/splash_event.dart';
import 'package:tourist_guide/bloc/splash_bloc/splash_state.dart';
import 'package:tourist_guide/core/colors/colors.dart';
import 'package:tourist_guide/core/widgets/custom_page_route.dart';
import 'package:tourist_guide/core/widgets/custom_snack_bar.dart';
import 'package:tourist_guide/data/firebase/auth_services.dart';
import 'package:tourist_guide/ui/auth/login.dart';
import 'package:tourist_guide/ui/home/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService().getUserData(FirebaseService().currentUser!.uid);

    return BlocProvider(
      create: (_) => SplashScreenBloc()..add(CheckLoginStatusEvent()),
      child: Scaffold(
        backgroundColor: kMainColor,
        body: SafeArea(
          child: BlocConsumer<SplashScreenBloc, SplashScreenState>(
            listener: (context, state) {
              if (state is SplashScreenNavigationState) {
                Navigator.of(context).pushReplacement(
                  CustomPageRoute(
                    child:
                        state.isLoggedIn ? const HomeScreen() : const Login(),
                    type: PageTransitionType.slideUp,
                    duration: const Duration(seconds: 3),
                    curve: Curves.easeInOutCubic,
                  ),
                );
              }

              if (state is SplashScreenErrorState) {
                CustomSnackBar.showError(
                  context: context,
                  message: state.error,
                );
              }
            },
            builder: (context, state) {
              if (state is SplashScreenLoadingState ||
                  state is SplashScreenInitialState) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                );
              }

              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Lottie Animation
                      Lottie.asset(
                        'assets/images/splash_animation.json',
                        height: 300.h,
                        animate: true,
                      ),
                      SizedBox(height: 40.h),
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
                      SizedBox(height: 50.h),
                      if (state is! SplashScreenErrorState)
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<SplashScreenBloc>()
                                .add(NavigateToNextScreenEvent());
                          },
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
                            state is SplashScreenLoggedInState
                                ? 'Continue to Home'
                                : 'Get Started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (state is SplashScreenErrorState)
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<SplashScreenBloc>()
                                .add(CheckLoginStatusEvent());
                          },
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
                            'Retry',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
